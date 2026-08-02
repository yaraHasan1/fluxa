import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/splash/splash_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

/// Renders the splash at the design frame so the composition can be compared
/// against the Figma export. Run with `flutter test --update-goldens`.
void main() {
  testWidgets('splash matches the design frame', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await svg.cache.putIfAbsent(
        SvgAssetLoader(AppAssets.splashArt).cacheKey(null),
        () => const SvgAssetLoader(AppAssets.splashArt).loadBytes(null),
      );
    });

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SplashScreen()),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash.png'),
    );
  });
}
