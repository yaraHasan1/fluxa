import 'package:flutter/animation.dart';

/// The app's motion vocabulary.
///
/// Every animation in Fluxa draws its duration and curve from here, which is
/// what makes independently authored screens feel like one product. Values are
/// tuned short enough to stay responsive on low-end devices.
abstract final class AppDurations {
  /// Micro-feedback: ripples, colour changes, icon swaps.
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 360);
  static const Duration slow = Duration(milliseconds: 560);

  /// Route changes.
  static const Duration route = Duration(milliseconds: 420);
  static const Duration routeReverse = Duration(milliseconds: 300);

  /// Ambient loops (float, glow, broadcast pulse).
  static const Duration idleFloat = Duration(milliseconds: 3200);
  static const Duration glowPulse = Duration(milliseconds: 1800);
  static const Duration broadcast = Duration(milliseconds: 2200);

  /// Full splash choreography, from first frame to hand-off.
  static const Duration splashSequence = Duration(milliseconds: 2600);

  /// How long the mascot lingers after the sequence completes, so the user is
  /// not yanked out of the reveal.
  static const Duration splashHold = Duration(milliseconds: 500);
}

/// Curves, named by intent rather than by shape.
abstract final class AppCurves {
  /// Default for elements arriving on screen: fast out, settled landing.
  static const Curve enter = Curves.easeOutCubic;

  /// Elements leaving: accelerates away.
  static const Curve exit = Curves.easeInCubic;

  /// Emphasised entrance with a restrained overshoot. Used for the logo reveal.
  static const Curve emphasised = Curves.easeOutBack;

  /// Symmetric ease for ambient loops that reverse.
  static const Curve ambient = Curves.easeInOut;

  /// Bi-directional transitions where neither end should dominate.
  static const Curve standard = Curves.easeInOutCubic;
}

/// Distances for slide/offset motion, in logical pixels before responsive
/// scaling. Kept small — premium motion is quiet motion.
abstract final class AppOffsets {
  static const double slideSmall = 16;
  static const double slideMedium = 28;
  static const double floatAmplitude = 8;
}
