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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                AppColors.mintDeep,
                AppColors.tealBright,
                AppColors.teal,
              ],
              stops: <double>[0.0, 0.45, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
