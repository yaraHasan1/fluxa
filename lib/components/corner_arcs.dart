import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/constants/app_assets.dart';

/// Which corner the arcs radiate from.
enum ArcCorner { topLeft, bottomRight }

/// The concentric "broadcast" arcs that bracket the splash, echoing the
/// mascot's antenna waves.
class CornerArcs extends StatelessWidget {
  const CornerArcs({super.key, required this.corner, required this.size});

  final ArcCorner corner;

  /// Width the arc artwork is laid out at; height follows its 170×167 ratio.
  final double size;

  /// Intrinsic aspect ratio of [AppAssets.cornerArcs].
  static const double aspect = 170 / 167;

  @override
  Widget build(BuildContext context) {
    final Widget arcs = SvgPicture.asset(
      AppAssets.cornerArcs,
      width: size,
      height: size / aspect,
      fit: BoxFit.contain,
    );

    return IgnorePointer(
      child: switch (corner) {
        // The export is a top-left corner; a half turn yields the mirrored
        // bottom-right instance.
        ArcCorner.topLeft => arcs,
        ArcCorner.bottomRight => Transform.rotate(angle: math.pi, child: arcs),
      },
    );
  }
}
