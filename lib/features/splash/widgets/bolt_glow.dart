import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/animations/animation_constants.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/theme/app_colors.dart';

/// Lights the mascot's chest bolt.
///
/// The bolt already exists inside `splash_art.svg`; this paints a tinted copy
/// *over* it at the same viewBox and width, so the two register exactly with
/// no offset to maintain. Two layers do the work: a blurred halo that spills
/// past the silhouette, and a crisp core that brightens the bolt itself.
///
/// It charges once on arrival, then settles into a slow breath so the mascot
/// stays alive for the rest of the hold.
class BoltGlow extends StatefulWidget {
  const BoltGlow({
    super.key,
    required this.width,
    this.delay = const Duration(milliseconds: 900),
    this.animate = true,
  });

  /// Must match the width [AppAssets.splashArt] is laid out at.
  final double width;

  /// How long to wait before the bolt charges — long enough for the swoosh to
  /// have drawn most of the way.
  final Duration delay;

  /// When false the bolt sits at full brightness and no ticker runs.
  final bool animate;

  /// Brightness the breath falls back to between peaks.
  static const double _ebb = 0.45;

  @override
  State<BoltGlow> createState() => _BoltGlowState();
}

class _BoltGlowState extends State<BoltGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.slow,
  );

  late final Animation<double> _intensity = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.ambient,
  );

  /// Held so the pending delay can be cancelled on dispose — an uncancellable
  /// `Future.delayed` would outlive the screen.
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    if (!widget.animate) {
      _controller.value = 1;
      return;
    }
    _delay = Timer(widget.delay, _charge);
  }

  Future<void> _charge() async {
    await _controller.forward();
    if (!mounted) return;

    // Hand off from the one-shot charge to an endless breath.
    _controller.repeat(
      min: BoltGlow._ebb,
      max: 1,
      reverse: true,
      period: AppDurations.glowPulse,
    );
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sigma = widget.width * 0.022;

    final Widget bolt = SvgPicture.asset(
      AppAssets.splashBolt,
      width: widget.width,
      fit: BoxFit.contain,
      colorFilter: const ColorFilter.mode(AppColors.mintLight, BlendMode.srcIn),
    );

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _intensity,
        child: bolt,
        builder: (BuildContext context, Widget? child) {
          final double v = _intensity.value;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Halo — spills past the bolt onto the chest plate.
              Opacity(
                opacity: 0.55 * v,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: sigma,
                    sigmaY: sigma,
                  ),
                  child: child,
                ),
              ),
              // Core — keeps the bolt's edge readable at peak brightness.
              Opacity(opacity: 0.5 * v, child: child),
            ],
          );
        },
      ),
    );
  }
}
