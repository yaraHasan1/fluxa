import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/signup/signup_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

import 'test_fonts.dart';

/// Renders the signup frame at the design size so the blob, card and four
/// fields can be compared against the Figma export.
/// Run with `flutter test --update-goldens`.
void main() {
  testWidgets('signup matches the design frame', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(loadDisplayFont);

    await tester.runAsync(() async {
      await svg.cache.putIfAbsent(
        SvgAssetLoader(AppAssets.splashArt).cacheKey(null),
        () => SvgAssetLoader(AppAssets.splashArt).loadBytes(null),
      );
    });

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SignupScreen()),
    );
    await tester.pump();

    await expectLater(
      find.byType(SignupScreen),
      matchesGoldenFile('goldens/signup.png'),
    );
  });
}
