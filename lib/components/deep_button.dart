import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The pill action used on the deep teal frames.
///
/// Unlike [PrimaryButton] this is a tint of the ground with a light hairline
/// rather than a solid fill — on the saturated surface the design's button
/// reads as recessed, not raised.
class DeepButton extends StatelessWidget {
  const DeepButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.horizontalPadding = 34,
  });

  final String label;

  /// A null callback renders the disabled state.
  final VoidCallback? onPressed;

  /// Design-frame horizontal padding; scaled responsively.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final BorderRadius radius = BorderRadius.circular(context.r(20));

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: AppColors.tealDark.withValues(alpha: 0.55),
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.onDeepMuted, width: 1.2),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.r(horizontalPadding),
              vertical: context.r(9),
            ),
            child: Text(
              label,
              style: AppTextStyles.deepButton.copyWith(
                fontSize: context.sp(17),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
