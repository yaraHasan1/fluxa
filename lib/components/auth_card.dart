import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The translucent, teal-edged panel every auth form sits inside.
///
/// It is deliberately semi-transparent: the background artwork reads through
/// it in the design, which is what keeps the form from looking pasted on.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.r(22)),
        border: Border.all(color: AppColors.teal, width: context.r(2)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.r(20),
          vertical: context.r(24),
        ),
        child: child,
      ),
    );
  }
}
