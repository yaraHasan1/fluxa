import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/onboarding/onboarding_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

/// Renders the welcome frame at the design size so the crop of the mascot and
/// the copy block can be compared against the Figma export.
/// Run with `flutter test --update-goldens`.
void main() {
  testWidgets('onboarding matches the design frame', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await svg.cache.putIfAbsent(
        SvgAssetLoader(AppAssets.splashArt).cacheKey(null),
        () => SvgAssetLoader(AppAssets.splashArt).loadBytes(null),
      );
    });

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const OnboardingScreen()),
    );
    await tester.pump();

    await expectLater(
      find.byType(OnboardingScreen),
      matchesGoldenFile('goldens/onboarding.png'),
    );
  });
}
