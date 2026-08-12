import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/circle_chevron_button.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/settings/widgets/settings_row.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/routes/app_nav.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The organisation sub-menu: a small panel offering the two organisation
/// actions. Reuses [SettingsRow] so the two menus stay identical in weight.
class OrganisationSettingsScreen extends StatelessWidget {
  const OrganisationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.deepGradient,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: context.r(4),
                right: context.wp(0.05),
                child: CircleChevronButton(
                  onPressed: () => context.backOr(AppRoutes.settings),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.wp(0.16)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.r(14),
                      vertical: context.r(10),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(context.r(12)),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          AppStrings.companyName,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: context.sp(14),
                            color: AppColors.tealDark,
                          ),
                        ),
                        SizedBox(height: context.r(6)),
                        SettingsRow(
                          label: AppStrings.addOrganisation,
                          iconAsset: AppAssets.iconAddOrg,
                          onTap: () =>
                              context.goNamed(AppRoutes.addOrganisation),
                        ),
                        SettingsRow(
                          label: AppStrings.organisationalChange,
                          iconAsset: AppAssets.iconArrowCircle,
                          onTap: () =>
                              context.goNamed(AppRoutes.organisationsList),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
