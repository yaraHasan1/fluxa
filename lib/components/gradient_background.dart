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
      child: child,
    );
  }
}
