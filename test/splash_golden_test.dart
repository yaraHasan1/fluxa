import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/features/splash/splash_screen.dart';
import 'package:fluxa/theme/app_theme.dart';

/// Renders the splash at the design frame so the composition can be compared
/// against the Figma export. Run with `flutter test --update-goldens`.
///
/// Every asset is decoded up front: `SvgPicture` resolves asynchronously, and
/// a widget test's clock does not run real async work, so an un-primed cache
/// renders as empty boxes.
///
/// The screen animates, so each golden names the moment it captures. The test
/// clock is deterministic, so a given pump total always yields the same frame.
Future<void> _primeSvgCache() async {
  for (final String path in <String>[
    AppAssets.splashArt,
    AppAssets.splashBolt,
    AppAssets.splashSwoosh,
    ...AppAssets.cornerArcLayers,
  ]) {
    await svg.cache.putIfAbsent(
      SvgAssetLoader(path).cacheKey(null),
      () => SvgAssetLoader(path).loadBytes(null),
    );
  }
}

/// Advances the clock in frame-sized steps.
///
/// A single large `pump` will not do: it fires the delay timers, but the
/// controllers they start then get no frames to advance through, so every
/// animation reads as still sitting at zero.
Future<void> _advance(WidgetTester tester, Duration total) async {
  const Duration frame = Duration(milliseconds: 16);
  for (Duration t = Duration.zero; t < total; t += frame) {
    await tester.pump(frame);
  }
}

Future<void> _pumpSplash(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.runAsync(_primeSvgCache);
  await tester.pumpWidget(
    MaterialApp(theme: AppTheme.light, home: const SplashScreen()),
  );
}

void main() {
  testWidgets('splash matches the design frame once settled', (
    WidgetTester tester,
  ) async {
    await _pumpSplash(tester);

    // Past the swoosh draw (260 + 1100) and the bolt charge (900 + 560), but
    // short of SplashCubit.hold at 2500 so nothing has navigated away.
    await _advance(tester, const Duration(milliseconds: 1600));

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash.png'),
    );
  });

  testWidgets('swoosh is partway drawn mid-sequence', (
    WidgetTester tester,
  ) async {
    await _pumpSplash(tester);

    // Mid-wipe: the cable should be cut off short of its right-hand hook.
    await _advance(tester, const Duration(milliseconds: 700));

    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_drawing.png'),
    );
  });
}
