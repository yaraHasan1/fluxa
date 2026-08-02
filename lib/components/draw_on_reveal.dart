import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluxa/animations/animation_constants.dart';

/// Wipes a child into view from one edge, as though it were being drawn.
///
/// The swoosh is a *filled* ribbon, not a stroked path, so the usual
/// `PathMetrics` dash trick does not apply — tracing its outline would draw
/// the silhouette's border rather than the cable. Clipping a growing rect
/// across it reads as the line extending, and costs one clip per frame.
///
/// Layout is unaffected: the child always occupies its full size, and only the
/// painted region grows.
class DrawOnReveal extends StatefulWidget {
  const DrawOnReveal({
    super.key,
    required this.child,
    this.duration = AppDurations.slow,
    this.delay = Duration.zero,
    this.curve = AppCurves.enter,
    this.direction = AxisDirection.right,
    this.enabled = true,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  /// The edge the reveal grows *towards*.
  final AxisDirection direction;

  /// When false the child is painted whole, with no controller driven. Golden
  /// tests and reduced-motion callers use this.
  final bool enabled;

  @override
  State<DrawOnReveal> createState() => _DrawOnRevealState();
}

class _DrawOnRevealState extends State<DrawOnReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _fraction = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  /// Held so the pending delay can be cancelled on dispose — an uncancellable
  /// `Future.delayed` would outlive the screen.
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    if (!widget.enabled) {
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delay = Timer(widget.delay, _controller.forward);
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _fraction,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => ClipRect(
        clipper: _WipeClipper(_fraction.value, widget.direction),
        child: child,
      ),
    );
  }
}

class _WipeClipper extends CustomClipper<Rect> {
  const _WipeClipper(this.fraction, this.direction);

  final double fraction;
  final AxisDirection direction;

  @override
  Rect getClip(Size size) {
    final double w = size.width * fraction;
    final double h = size.height * fraction;

    return switch (direction) {
      AxisDirection.right => Rect.fromLTWH(0, 0, w, size.height),
      AxisDirection.left => Rect.fromLTWH(size.width - w, 0, w, size.height),
      AxisDirection.down => Rect.fromLTWH(0, 0, size.width, h),
      AxisDirection.up => Rect.fromLTWH(0, size.height - h, size.width, h),
    };
  }

  @override
  bool shouldReclip(_WipeClipper old) =>
      old.fraction != fraction || old.direction != direction;
}
