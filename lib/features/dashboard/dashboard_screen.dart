import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/animations/animation_constants.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/features/dashboard/widgets/circuit_breaker_tile.dart';
import 'package:fluxa/features/dashboard/widgets/dashboard_backdrop.dart';
import 'package:fluxa/features/dashboard/widgets/energy_sources_card.dart';
import 'package:fluxa/features/dashboard/widgets/production_card.dart';
import 'package:fluxa/features/dashboard/widgets/status_card.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// System overview: greeting, status, production and the breaker list.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.userName = ''});

  /// Shown after "Good morning". Empty until an account is signed in.
  final String userName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => DashboardCubit(),
      child: _DashboardView(userName: userName),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: DashboardBackdrop()),

            SafeArea(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (BuildContext context, DashboardState state) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: context.wp(0.05)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: context.hp(0.02)),
                        _Greeting(userName: userName),
                        SizedBox(height: context.hp(0.03)),
                        const _HeaderActions(),
                        SizedBox(height: context.hp(0.012)),

                        _SectionTitle(AppStrings.currentConsumption),
                        SizedBox(height: context.r(8)),
                        StatusCard(status: state.status),
                        SizedBox(height: context.r(18)),

                        // Tapping anywhere in the section swaps the compact
                        // row for a card per source.
                        InkWell(
                          onTap: context.read<DashboardCubit>().toggleSources,
                          borderRadius: BorderRadius.circular(context.r(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _SectionTitle(
                                AppStrings.energySources,
                                trailing: AppStrings.energySourcesCaption,
                                expanded: state.sourcesExpanded,
                              ),
                              SizedBox(height: context.r(8)),
                              AnimatedSize(
                                duration: AppDurations.medium,
                                curve: AppCurves.standard,
                                alignment: Alignment.topCenter,
                                child: state.sourcesExpanded
                                    ? _ProductionList(sources: state.sources)
                                    : EnergySourcesCard(sources: state.sources),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.r(18)),

                        _SectionTitle(AppStrings.circuitBreakers),
                        SizedBox(height: context.r(8)),
                        for (int i = 0; i < state.breakers.length; i++)
                          CircuitBreakerTile(
                            breaker: state.breakers[i],
                            onChanged: (bool on) => context
                                .read<DashboardCubit>()
                                .toggleBreaker(i, on),
                          ),

                        SizedBox(height: context.hp(0.03)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${AppStrings.greetingPrefix}$userName'.trimRight(),
          style: AppTextStyles.greeting.copyWith(fontSize: context.sp(20)),
        ),
        SizedBox(height: context.r(2)),
        Padding(
          padding: EdgeInsets.only(left: context.wp(0.04)),
          child: Text(
            AppStrings.greetingSubtitle,
            style: AppTextStyles.greeting.copyWith(
              fontSize: context.sp(10),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bell and gear, sitting under the discs on the right.
class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // The exports carry their own teal, so they are not re-tinted.
        _HeaderIcon(
          asset: AppAssets.iconBell,
          tooltip: AppStrings.notifications,
          onPressed: () => context.goNamed(AppRoutes.notifications),
        ),
        SizedBox(width: context.r(6)),
        _HeaderIcon(
          asset: AppAssets.iconCog,
          tooltip: AppStrings.settings,
          onPressed: () => context.goNamed(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.asset,
    required this.tooltip,
    required this.onPressed,
  });

  final String asset;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double size = context.r(24);

    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: size,
        child: Padding(
          padding: EdgeInsets.all(context.r(4)),
          child: SvgPicture.asset(
            asset,
            width: size,
            height: size,
            fit: BoxFit.contain,
            semanticsLabel: tooltip,
          ),
        ),
      ),
    );
  }
}

/// The three per-source cards the Energy sources section expands into.
class _ProductionList extends StatelessWidget {
  const _ProductionList({required this.sources});

  final List<EnergySource> sources;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < sources.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: context.r(10)),
          ProductionCard(
            kind: sources[i].kind,
            kilowatts: sources[i].kilowatts,
            caption: sources[i].kind.productionCaption,
            badge: sources[i].chargePercent == null
                ? null
                : '${sources[i].chargePercent}%',
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing, this.expanded});

  final String title;
  final String? trailing;

  /// Null on sections that do not expand, so they show no chevron at all.
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: context.sp(15)),
        ),
        if (expanded != null)
          AnimatedRotation(
            turns: expanded! ? 0.5 : 0,
            duration: AppDurations.medium,
            curve: AppCurves.standard,
            child: Icon(
              Icons.expand_more,
              size: context.r(18),
              color: AppColors.ink,
            ),
          ),
        if (trailing != null) ...<Widget>[
          const Spacer(),
          Text(
            trailing!,
            style: AppTextStyles.helper.copyWith(fontSize: context.sp(9)),
          ),
        ],
      ],
    );
  }
}
