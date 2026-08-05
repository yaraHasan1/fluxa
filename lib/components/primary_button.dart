import 'package:flutter/material.dart';

import 'package:fluxa/animations/animation_constants.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The filled pill action used across the flow — "next", "confirm", "Log in",
/// "Submit".
///
/// Sizes itself from its label unless [expand] is set, so the same widget
/// serves both the compact "next" on onboarding and the full-width buttons on
/// the auth forms.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
  });

  final String label;

  /// A null callback renders the disabled state.
  final VoidCallback? onPressed;

  /// Stretches to the full width of the parent instead of hugging the label.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    final Widget button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.glow.withValues(alpha: enabled ? 0.55 : 0.0),
            blurRadius: context.r(18),
            spreadRadius: enabled ? context.r(1) : 0,
            offset: Offset(0, context.r(6)),
          ),
          BoxShadow(
            color: AppColors.teal.withValues(alpha: enabled ? 0.08 : 0.0),
            blurRadius: context.r(10),
            offset: Offset(0, context.r(2)),
          ),
        ],
      ),
      child: Material(
        color: enabled ? AppColors.teal : AppColors.shellMid,
        borderRadius: BorderRadius.circular(context.r(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.standard,
            padding: EdgeInsets.symmetric(
              horizontal: context.r(26),
              vertical: context.r(10),
            ),
            // A non-null alignment makes the container expand to its
            // constraints, which is right only when stretching on purpose.
            alignment: expand ? Alignment.center : null,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.button.copyWith(fontSize: context.sp(24),
              color: AppColors.mintLight, 
              ),
             
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
