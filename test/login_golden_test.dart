import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/login/login_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

import 'test_fonts.dart';

/// Renders the login frame at the design size so the card, fields and title
/// can be compared against the Figma export.
/// Run with `flutter test --update-goldens`.
void main() {
  testWidgets('login matches the design frame', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(loadDisplayFont);

    await tester.runAsync(() async {
      for (final String path in <String>[
        AppAssets.splashArt,
        AppAssets.splashSwoosh,
      ]) {
        await svg.cache.putIfAbsent(
          SvgAssetLoader(path).cacheKey(null),
          () => SvgAssetLoader(path).loadBytes(null),
        );
      }
    });

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pump();

    await expectLater(
      find.byType(LoginScreen),
      matchesGoldenFile('goldens/login.png'),
    );
  });
}
