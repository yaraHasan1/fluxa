import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/onboarding/onboarding_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

import 'test_support.dart';

/// Renders the onboarding frame at the design size so it can be compared against the
/// Figma export. Run with `flutter test --update-goldens`.
void main() {
  testWidgets('onboarding matches the design frame', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(loadDisplayFont);
    await tester.runAsync(() => precacheSvgs(<String>[AppAssets.fluxaSide]));

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
