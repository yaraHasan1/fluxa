import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/circle_chevron_button.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/settings/widgets/settings_row.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The settings panel: a titled list of destinations on the deep wash, with
/// the mascot tucked into the bottom-left corner.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.deepGradient,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              // Sits behind the list and bleeds off the bottom-left corner.
              Positioned(
                left: -context.wp(0.08),
                bottom: -context.hp(0.02),
                width: context.wp(0.62),
                child: IgnorePointer(
                  child: SvgPicture.asset(
                    AppAssets.fluxaSettings,
                    fit: BoxFit.contain,
                    semanticsLabel: AppStrings.semanticsLogo,
                  ),
                ),
              ),

              Positioned(
                top: context.r(8),
                right: context.wp(0.05),
                child: CircleChevronButton(onPressed: () => context.pop()),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.wp(0.08)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: context.hp(0.09)),
                    Center(
                      child: Text(
                        AppStrings.settingsTitle,
                        style: AppTextStyles.wordmark.copyWith(
                          fontSize: context.sp(26),
                          color: AppColors.tealDark,
                        ),
                      ),
                    ),
                    SizedBox(height: context.hp(0.05)),
                    _Panel(
                      children: <Widget>[
                        SettingsRow(
                          label: AppStrings.organisationalSettings,
                          iconAsset: AppAssets.iconChevronSolid,
                          onTap: () =>
                              context.goNamed(AppRoutes.organisationSettings),
                        ),
                        SettingsRow(
                          label: AppStrings.history,
                          iconAsset: AppAssets.iconHistory,
                          onTap: () => context.goNamed(AppRoutes.history),
                        ),
                        SettingsRow(
                          label: AppStrings.notificationsRow,
                          iconAsset: AppAssets.iconBell,
                          onTap: () => context.goNamed(AppRoutes.notifications),
                        ),
                        SettingsRow(
                          label: AppStrings.changePassword,
                          iconAsset: AppAssets.iconChangePassword,
                          onTap: () =>
                              context.goNamed(AppRoutes.changePassword),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The translucent slab the rows sit on.
class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(14),
        vertical: context.r(6),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.r(14)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
