import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens.
///
/// Font *size* is deliberately omitted from most tokens: screens supply it via
/// the responsive helpers so text scales with the viewport instead of being
/// pinned to a design-time pixel value.
abstract final class AppTextStyles {
  /// The FLUXA wordmark — heavy, widely tracked, brand teal.
  static const TextStyle wordmark = TextStyle(
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

  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.navy,
    height: 1.4,
  );
}
