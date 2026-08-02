import 'package:flutter/material.dart';

import 'package:fluxa/animations/page_transitions.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';

/// Application-wide [ThemeData].
///
/// The page-transition theme is wired here so *every* implicit `Navigator.push`
/// inherits the brand motion system rather than the platform default.
abstract final class AppTheme {
  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      primary: AppColors.teal,
      secondary: AppColors.mintDeep,
      surface: AppColors.backgroundTop,
      onSurface: AppColors.navy,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Sirin Stencil',
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.backgroundTop,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.wordmark,
        titleMedium: AppTextStyles.tagline,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FluxaPageTransitionsBuilder(),
          TargetPlatform.iOS: FluxaPageTransitionsBuilder(),
          TargetPlatform.windows: FluxaPageTransitionsBuilder(),
          TargetPlatform.macOS: FluxaPageTransitionsBuilder(),
          TargetPlatform.linux: FluxaPageTransitionsBuilder(),
        },
      ),
    );
  }
}
