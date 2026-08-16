import 'package:flutter/material.dart';

import 'package:fluxa/components/back_scope.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_nav.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The floating panel the organisation flows use: a dismiss cross, a title, a
/// body, and an optional action in the bottom-right.
///
/// It is a screen rather than a `showDialog`, because the flow has real routes
/// — but it is laid out as a card over a dimmed ground so it reads as a modal.
class PanelDialog extends StatelessWidget {
  const PanelDialog({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.onSubmit,
    this.submitLabel = AppStrings.submit,
    this.upRoute = AppRoutes.organisationSettings,
  });

  final String title;
  final Widget child;

  /// Defaults to popping the route.
  final VoidCallback? onClose;

  /// Where the system back lands when there is nothing to pop. These panels
  /// are all steps of the organisation flow, so that is the default.
  final String upRoute;

  /// Omitted, no action row is drawn.
  final VoidCallback? onSubmit;
  final String submitLabel;

  @override
  Widget build(BuildContext context) {
    return BackScope(upRoute: upRoute, child: _panel(context));
  }

  Widget _panel(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy.withValues(alpha: 0.45),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.wp(0.09)),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                context.r(16),
                context.r(10),
                context.r(16),
                context.r(14),
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundTop,
                borderRadius: BorderRadius.circular(context.r(14)),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkResponse(
                      onTap:
                          onClose ?? () => context.backOr(upRoute),
                      radius: context.r(16),
                      child: Icon(
                        Icons.close,
                        size: context.r(16),
                        color: AppColors.tealDark,
                      ),
                    ),
                  ),
                  SizedBox(height: context.r(2)),
                  Text(
                    title,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: context.sp(17),
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.r(16)),
                  child,
                  if (onSubmit != null) ...<Widget>[
                    SizedBox(height: context.r(14)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: onSubmit,
                        child: Padding(
                          padding: EdgeInsets.all(context.r(4)),
                          child: Text(
                            submitLabel,
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: context.sp(13),
                              color: AppColors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
