import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/brand_blob.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:fluxa/features/dashboard/widgets/circuit_breaker_tile.dart';
import 'package:fluxa/features/dashboard/widgets/energy_sources_card.dart';
import 'package:fluxa/features/dashboard/widgets/status_card.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The header blob is mostly off the top of the frame; only its lower arc
/// shows behind the greeting.
const double _blobDiameterFactor = 1.55;
const double _blobTopFactor = -0.30;

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
    final double width = context.screenWidth;
    final double blob = width * _blobDiameterFactor;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: (width - blob) / 2,
              top: context.screenHeight * _blobTopFactor,
              child: BrandBlob(diameter: blob),
            ),

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
                        StatusCard(
                          status: state.status,
                          kilowatts: state.consumptionKw,
                        ),
                        SizedBox(height: context.r(18)),

                        _SectionTitle(
                          AppStrings.energySources,
                          trailing: AppStrings.energySourcesCaption,
                        ),
                        SizedBox(height: context.r(8)),
                        EnergySourcesCard(sources: state.sources),
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

/// Bell and gear, sitting under the blob on the right.
class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // PLACEHOLDER: the bell and gear artwork has not been supplied yet.
        IconButton(
          onPressed: () => context.goNamed(AppRoutes.notifications),
          icon: Icon(Icons.notifications_none, size: context.r(22)),
          color: AppColors.onDeep,
          tooltip: AppStrings.notifications,
        ),
        IconButton(
          onPressed: () => context.goNamed(AppRoutes.settings),
          icon: Icon(Icons.settings_outlined, size: context.r(22)),
          color: AppColors.onDeep,
          tooltip: AppStrings.settings,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: context.sp(15)),
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
