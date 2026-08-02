import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/animations/animation_constants.dart';
import 'package:fluxa/constants/app_assets.dart';

/// Which corner the arcs radiate from.
enum ArcCorner { topLeft, bottomRight }

/// The concentric "broadcast" arcs that bracket the splash, echoing the
/// mascot's antenna waves.
///
/// The three arcs light in sequence from the corner outwards, so the corner
/// reads as a transmitter rather than as a blinking decoration. Each arc is a
/// separate export sharing one viewBox, so stacking them reproduces the
/// original single-file artwork exactly.
class CornerArcs extends StatefulWidget {
  const CornerArcs({
    super.key,
    required this.corner,
    required this.size,
    this.animate = true,
  });

  final ArcCorner corner;

  /// Width the arc artwork is laid out at; height follows its 170×167 ratio.
  final double size;

  /// When false every arc paints at full strength and no ticker runs.
  final bool animate;

  /// Intrinsic aspect ratio of the corner artwork.
  static const double aspect = 170 / 167;

  /// How far each arc trails the one inside it, as a fraction of the cycle.
  static const double _stagger = 0.15;

  /// Strength an arc rests at between pulses. Never zero — the arcs are part
  /// of the static composition, and blinking them out would read as a glitch.
  static const double _rest = 0.42;

  @override
  State<CornerArcs> createState() => _CornerArcsState();
}

class _CornerArcsState extends State<CornerArcs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.broadcast,
  );

  late final List<Animation<double>> _pulses = List<Animation<double>>.generate(
    AppAssets.cornerArcLayers.length,
    _pulseFor,
  );

  /// A rest → full → rest swell, delayed by the arc's distance from the corner.
  Animation<double> _pulseFor(int index) {
    final double start = index * CornerArcs._stagger;

    return TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: CornerArcs._rest,
          end: 1,
        ).chain(CurveTween(curve: AppCurves.ambient)),
        weight: 30,
      ),
      TweenSequenceItem<double>(tween: ConstantTween<double>(1), weight: 10),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 1,
          end: CornerArcs._rest,
        ).chain(CurveTween(curve: AppCurves.ambient)),
        weight: 60,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Interval(start, 1)));
  }

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(CornerArcs old) {
    super.didUpdateWidget(old);
    if (widget.animate == old.animate) return;
    widget.animate ? _controller.repeat() : _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.size / CornerArcs.aspect;

    Widget layer(int index) {
      final Widget arc = SvgPicture.asset(
        AppAssets.cornerArcLayers[index],
        width: widget.size,
        height: height,
        fit: BoxFit.contain,
      );

      if (!widget.animate) return arc;

      return AnimatedBuilder(
        animation: _pulses[index],
        child: arc,
        builder: (BuildContext context, Widget? child) {
          final double v = _pulses[index].value;
          return Opacity(
            opacity: v,
            // Scaling from the corner makes the swell travel outwards along
            // the arc rather than inflating it in place.
            child: Transform.scale(
              scale: 0.97 + 0.03 * v,
              alignment: Alignment.topLeft,
              child: child,
            ),
          );
        },
      );
    }

    final Widget arcs = SizedBox(
      width: widget.size,
      height: height,
      child: Stack(
        children: <Widget>[
          for (int i = 0; i < AppAssets.cornerArcLayers.length; i++) layer(i),
        ],
      ),
    );

    return IgnorePointer(
      child: switch (widget.corner) {
        // The export is a top-left corner; a half turn yields the mirrored
        // bottom-right instance.
        ArcCorner.topLeft => arcs,
        ArcCorner.bottomRight => Transform.rotate(angle: math.pi, child: arcs),
      },
    );
  }
}
