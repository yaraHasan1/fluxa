import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// One-shot entrance: fades in while travelling a short distance.
///
/// Prefer this over hand-written controllers for arriving content — a shared
/// [delay] scale across a screen is what produces a deliberate stagger rather
/// than everything popping at once.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.slow,
    this.offset = const Offset(0, AppOffsets.slideMedium),
    this.curve = AppCurves.enter,
    this.beginScale = 1.0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Starting displacement in logical pixels; animates to [Offset.zero].
  final Offset offset;
  final Curve curve;

  /// Optional scale to grow from. `1.0` disables the scale component.
  final double beginScale;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _t =
      CurvedAnimation(parent: _controller, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) {
        final double v = _t.value;
        return Opacity(
          opacity: _controller.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset.lerp(widget.offset, Offset.zero, v)!,
            child: widget.beginScale == 1.0
                ? child
                : Transform.scale(
                    scale: lerpDouble(widget.beginScale, 1.0, v)!,
                    child: child,
                  ),
          ),
        );
      },
    );
  }
}

/// Endless, low-amplitude vertical drift. Gives a static mascot the sense of
/// being alive without drawing attention to itself.
class AmbientFloat extends StatefulWidget {
  const AmbientFloat({
    super.key,
    required this.child,
    this.amplitude = AppOffsets.floatAmplitude,
    this.period = AppDurations.idleFloat,
    this.enabled = true,
  });

  final Widget child;
  final double amplitude;
  final Duration period;

  /// Set false to freeze the loop (e.g. when reduced-motion is requested).
  final bool enabled;

  @override
  State<AmbientFloat> createState() => _AmbientFloatState();
}

class _AmbientFloatState extends State<AmbientFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AmbientFloat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final Animation<double> t =
        CurvedAnimation(parent: _controller, curve: AppCurves.ambient);
    return AnimatedBuilder(
      animation: t,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -widget.amplitude * t.value),
        child: child,
      ),
    );
  }
}

/// Breathing halo: pulses opacity and scale together so a glow reads as light
/// intensity rather than as a moving object.
class GlowPulse extends StatefulWidget {
  const GlowPulse({
    super.key,
    required this.child,
    this.period = AppDurations.glowPulse,
    this.minOpacity = 0.45,
    this.maxOpacity = 1.0,
    this.minScale = 0.94,
    this.maxScale = 1.06,
    this.enabled = true,
  });

  final Widget child;
  final Duration period;
  final double minOpacity;
  final double maxOpacity;
  final double minScale;
  final double maxScale;
  final bool enabled;

  @override
  State<GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<GlowPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final Animation<double> t =
        CurvedAnimation(parent: _controller, curve: AppCurves.ambient);
    return AnimatedBuilder(
      animation: t,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) => Opacity(
        opacity: lerpDouble(widget.minOpacity, widget.maxOpacity, t.value)!,
        child: Transform.scale(
          scale: lerpDouble(widget.minScale, widget.maxScale, t.value),
          child: child,
        ),
      ),
    );
  }
}

/// Squashes its child vertically at a slow, irregular-feeling interval — used
/// for the mascot's blink. [alignment] must sit on the eye line so the lids
/// appear to close towards the pupils.
class PeriodicBlink extends StatefulWidget {
  const PeriodicBlink({
    super.key,
    required this.child,
    this.period = const Duration(milliseconds: 3600),
    this.blinkDuration = const Duration(milliseconds: 160),
    this.alignment = Alignment.center,
    this.enabled = true,
  });

  final Widget child;

  /// Time between blinks, measured start-to-start.
  final Duration period;
  final Duration blinkDuration;
  final Alignment alignment;
  final bool enabled;

  @override
  State<PeriodicBlink> createState() => _PeriodicBlinkState();
}

class _PeriodicBlinkState extends State<PeriodicBlink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  /// The blink occupies only the tail of the cycle, so the eyes stay open for
  /// most of the loop.
  late final Animation<double> _lid = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(tween: ConstantTween<double>(1), weight: 88),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1, end: 0.06)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 5,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.06, end: 1)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 7,
    ),
  ]).animate(_controller);

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _lid,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) => Transform(
        alignment: widget.alignment,
        transform: Matrix4.diagonal3Values(1, _lid.value, 1),
        child: child,
      ),
    );
  }
}
