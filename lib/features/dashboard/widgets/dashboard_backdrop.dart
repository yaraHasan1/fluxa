import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// The dashboard's background: two overlapping teal discs across the top and a
/// soft mint bloom down each edge.
///
/// The discs are translucent rather than solid, so the crescent where they
/// cross darkens on its own instead of needing a third shape painted in.
class DashboardBackdrop extends StatelessWidget {
  const DashboardBackdrop({super.key});

  /// Both discs are a full frame-width across; only their lower arcs show.
  static const double _discDiameter = 1.0;

  /// Left disc sits low and further off the left edge; the right one is
  /// pushed up so its arc crosses the frame higher.
  static const double _leftDiscLeft = -0.39;
  static const double _leftDiscTop = -0.315;
  static const double _rightDiscLeft = 0.33;
  static const double _rightDiscTop = -0.28;

  /// Each disc alone; where they overlap the alpha compounds.
  static const double _discAlpha = 0.72;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final double w = c.maxWidth;
        final double h = c.maxHeight;
        final double disc = w * _discDiameter;

        return IgnorePointer(
          child: Stack(
            children: <Widget>[
              _EdgeBloom(
                width: w * 0.17,
                top: h * 0.17,
                bottom: h * 0.05,
                fromLeft: true,
              ),
              _EdgeBloom(
                width: w * 0.15,
                top: h * 0.24,
                bottom: h * 0.01,
                fromLeft: false,
              ),
              Positioned(
                left: w * _leftDiscLeft,
                top: h * _leftDiscTop,
                child: _Disc(diameter: disc),
              ),
              Positioned(
                left: w * _rightDiscLeft,
                top: h * _rightDiscTop,
                child: _Disc(diameter: disc),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Disc extends StatelessWidget {
  const _Disc({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            AppColors.mintDeep.withValues(
              alpha: DashboardBackdrop._discAlpha * 0.9,
            ),
            AppColors.teal.withValues(alpha: DashboardBackdrop._discAlpha),
          ],
        ),
        boxShadow: <BoxShadow>[
          // Reads as the disc lifting off the wash along its lower arc.
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.18),
            blurRadius: diameter * 0.035,
            offset: Offset(0, diameter * 0.012),
          ),
        ],
      ),
    );
  }
}

/// A vertical mint bloom hugging one edge, fading inwards.
class _EdgeBloom extends StatelessWidget {
  const _EdgeBloom({
    required this.width,
    required this.top,
    required this.bottom,
    required this.fromLeft,
  });

  final double width;
  final double top;
  final double bottom;
  final bool fromLeft;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: fromLeft ? 0 : null,
      right: fromLeft ? null : 0,
      top: top,
      bottom: bottom,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: fromLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: fromLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: <Color>[
              AppColors.mintDeep.withValues(alpha: 0.60),
              AppColors.mint.withValues(alpha: 0.18),
              Colors.transparent,
            ],
            stops: const <double>[0.0, 0.55, 1.0],
          ),
        ),
      ),
    );
  }
}
