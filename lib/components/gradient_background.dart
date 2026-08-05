import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// Full-bleed brand wash.
///
/// Defaults to the pale wash the splash, onboarding and the account forms sit
/// on. Pass [AppColors.deepGradient] for the teal frames — verification and the
/// password-recovery flow.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradient = AppColors.backgroundGradient,
  });

  final Widget child;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      // Without this the box shrinks to its child, and any screen whose
      // content is shorter than the viewport shows the scaffold colour below
      // the wash as a hard horizontal seam.
      child: SizedBox.expand(child: child),
    );
  }
}
