import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// The oversized soft circle that colours a corner of the auth frames.
///
/// Recreated as a widget rather than shipped as an asset: it is a plain
/// gradient-filled circle, so a vector export would cost bytes and a decode
/// for something `BoxDecoration` draws exactly. Position it with a [Positioned]
/// that pushes most of it off-screen — only the arc should be visible.
class BrandBlob extends StatelessWidget {
  const BrandBlob({super.key, required this.diameter, this.opacity = 1.0});

  final double diameter;

  /// Drop below 1 for the pale watermark treatment.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                AppColors.teal,
                AppColors.tealBright,
                AppColors.teal,
              ],
              stops: <double>[0.0, 0.45, 1.0],
            ),
            border: Border.all(
              color: AppColors.teal.withOpacity(0.18),
              width: diameter * 0.008,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.tealDark.withOpacity(0.12),
                blurRadius: diameter * 0.04,
                spreadRadius: diameter * 0.005,
                offset: Offset(diameter * 0.01, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
