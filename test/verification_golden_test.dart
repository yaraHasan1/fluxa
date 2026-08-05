import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/verification/verification_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

import 'test_support.dart';

/// Renders the verification frame at the design size. This is the first deep
/// teal surface, so it also covers the inverted palette.
/// Run with `flutter test --update-goldens`.
void main() {
  testWidgets('verification matches the design frame', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(loadDisplayFont);
    await tester.runAsync(
      () => precacheSvgs(<String>[AppAssets.fluxaBackground]),
    );

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const VerificationScreen()),
    );
    await tester.pump();

    await expectLater(
      find.byType(VerificationScreen),
      matchesGoldenFile('goldens/verification.png'),
    );
  });
}
