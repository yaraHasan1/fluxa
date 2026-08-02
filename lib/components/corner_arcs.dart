import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// Which corner the arcs radiate from.
enum ArcCorner { topLeft, bottomRight }

/// The concentric "broadcast" arcs that bracket the splash, echoing the
/// mascot's antenna waves.
///
/// Drawn rather than imported: the shape is four stroked arcs sharing an
/// origin, so a painter reproduces it exactly at any size without shipping —
/// or rasterising — another asset.
class CornerArcs extends StatelessWidget {
  const CornerArcs({super.key, required this.corner, required this.size});

  final ArcCorner corner;

  /// Length of the square the arcs are inscribed in; the outermost arc very
  /// nearly touches its far edges.
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget arcs = CustomPaint(
      size: Size.square(size),
      painter: const _CornerArcsPainter(),
      isComplex: true,
    );

    return IgnorePointer(
      child: switch (corner) {
        // The painter draws a top-left corner; a half turn yields the mirrored
        // bottom-right instance.
        ArcCorner.topLeft => arcs,
        ArcCorner.bottomRight => Transform.rotate(angle: math.pi, child: arcs),
      },
    );
  }
}

class _CornerArcsPainter extends CustomPainter {
  const _CornerArcsPainter();

  /// Arc radii as a fraction of the painted square.
  static const List<double> _radii = <double>[0.17, 0.45, 0.70, 0.95];

  /// How much of the quarter-turn each arc covers, innermost first. The short
  /// inner stub reads as a tick rather than a ring.
  static const List<double> _sweeps = <double>[0.30, 0.62, 0.70, 0.74];

  @override
  void paint(Canvas canvas, Size size) {
    final double extent = size.shortestSide;
    // Origin sits just outside the corner so the arcs bleed off-screen the way
    // they do in the design instead of closing into visible rings.
    const Offset origin = Offset.zero;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = AppColors.arcGradient.createShader(
        Rect.fromLTWH(0, 0, extent, extent),
      );

    for (int i = 0; i < _radii.length; i++) {
      final double radius = extent * _radii[i];
      final double sweep = (math.pi / 2) * _sweeps[i];
      // Centre each arc on the corner's 45° diagonal.
      final double start = (math.pi / 4) - (sweep / 2);

      paint.strokeWidth = extent * 0.075 * (i == 0 ? 0.8 : 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CornerArcsPainter oldDelegate) => false;
}
