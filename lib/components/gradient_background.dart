import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// Full-bleed brand wash used behind the splash and the other light frames.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      // Without this the box shrinks to its child, and any screen whose
      // content is shorter than the viewport shows the scaffold colour below
      // the wash as a hard horizontal seam.
      child: SizedBox.expand(child: child),
    );
  }
}
