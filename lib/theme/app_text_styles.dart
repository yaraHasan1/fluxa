import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';

/// Typography tokens.
///
/// Font *size* is deliberately omitted from most tokens: screens supply it via
/// the responsive helpers so text scales with the viewport instead of being
/// pinned to a design-time pixel value.
abstract final class AppTextStyles {
  /// The FLUXA wordmark — heavy, widely tracked, brand teal.
  static const TextStyle wordmark = TextStyle(
    fontFamily: 'Sirin Stencil',
    fontWeight: FontWeight.w800,
    color: AppColors.teal,
    letterSpacing: 1.6,
    height: 1.05,
  );

  /// "Control the " — the regular run of the tagline.
  static const TextStyle tagline = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.tealMid,
    letterSpacing: 0.2,
    height: 1.2,
  );

  /// "Flow" — the emphasised run of the tagline.
  static const TextStyle taglineAccent = TextStyle(
    fontWeight: FontWeight.w800,
    color: AppColors.tealMid,
    letterSpacing: 0.2,
    height: 1.2,
  );

  /// Screen titles — "Welcome", "LOGIN", "Sign Up", "settings".
  static const TextStyle heading = TextStyle(
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: 0.2,
    height: 1.1,
  );

  /// Supporting copy under a heading. Centred, brand teal, generous leading.
  static const TextStyle subtitle = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.teal,
    letterSpacing: 0.1,
    height: 1.45,
  );

  /// Label inside a filled pill action.
  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
    height: 1.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.navy,
    height: 1.4,
  );
}
