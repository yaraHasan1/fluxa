import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/components/inline_link.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/login/login_screen.dart';
import 'package:fluxa/features/signup/signup_screen.dart';
import 'package:fluxa/routes/app_router.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_theme.dart';

import 'test_support.dart';

/// Drives the real router, so a broken route name or an over-eager redirect
/// fails here rather than in the app.
Future<void> _pumpRouter(WidgetTester tester) async {
  // The default 800x600 test view is landscape; these screens lay out for a
  // phone, and the links sit below the fold there, so a tap would land on
  // nothing.
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.runAsync(loadDisplayFont);
  await tester.runAsync(
    () => precacheSvgs(<String>[
      AppAssets.fluxaSide,
      AppAssets.splashArt,
      AppAssets.loginRibbon,
      AppAssets.fluxaBackground,
    ]),
  );

  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: AppRouter.router),
  );

  AppRouter.router.goNamed(AppRoutes.login);
  await tester.pumpAndSettle();
}

/// The link whose bold run reads [action].
Finder _link(String action) =>
    find.byWidgetPredicate((Widget w) => w is InlineLink && w.action == action);

void main() {
  testWidgets('login links through to signup', (WidgetTester tester) async {
    await _pumpRouter(tester);
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(_link(AppStrings.signUp));
    await tester.pumpAndSettle();

    expect(find.byType(SignupScreen), findsOneWidget);
  });

  testWidgets('signup links back to login', (WidgetTester tester) async {
    await _pumpRouter(tester);

    AppRouter.router.goNamed(AppRoutes.signup);
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);

    await tester.tap(_link(AppStrings.login));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
