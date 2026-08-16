import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/back_scope.dart';
import 'package:fluxa/components/circle_chevron_button.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_nav.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Confirms an organisation request was filed.
///
/// The tick and mascot are one export, so the panel is artwork plus a line of
/// copy rather than a composed illustration.
class RequestSentScreen extends StatelessWidget {
  const RequestSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackScope(upRoute: AppRoutes.settings, child: _panel(context));
  }

  Widget _panel(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: context.r(8),
                right: context.wp(0.05),
                child: CircleChevronButton(
                  onPressed: () => context.backOr(AppRoutes.settings),
                ),
              ),
              Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.wp(0.12)),
              child: Container(
                padding: EdgeInsets.all(context.r(16)),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(context.r(18)),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.glow.withValues(alpha: 0.45),
                      blurRadius: context.r(18),
                      offset: Offset(0, context.r(6)),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppAssets.successCheck,
                      width: context.wp(0.5),
                      fit: BoxFit.contain,
                      semanticsLabel: AppStrings.requestSent,
                    ),
                    // The export already carries the wording, so the panel
                    // adds no copy of its own — AppStrings.requestSent exists
                    // only as the artwork's semantic label.
                    SizedBox(height: context.r(12)),
                    TextButton(
                      onPressed: () => context.goNamed(AppRoutes.settings),
                      child: Text(
                        AppStrings.confirm,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: context.sp(13),
                          color: AppColors.teal,
                        ),
                      ),
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
