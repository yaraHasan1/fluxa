import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The circled chevron that sits in the top-right of the deep frames.
///
/// The arrow points forward, so it is wired as "continue" rather than as a
/// back control.
class CircleChevronButton extends StatelessWidget {
  const CircleChevronButton({
    super.key,
    required this.onPressed,
    this.semanticLabel = 'Continue',
  });

  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double size = context.r(34);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: AppColors.teal,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.chevron_right,
              size: context.r(22),
              color: AppColors.onDeep,
            ),
          ),
        ),
      ),
    );
  }
}
