import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/app.dart';
import 'package:fluxa/constants/app_strings.dart';

void main() {
  testWidgets('splash shows the brand lockup', (WidgetTester tester) async {
    await tester.pumpWidget(const FluxaApp());
    await tester.pump();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byType(RichText), findsWidgets);
  });

  testWidgets('splash moves on to onboarding after the hold', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FluxaApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.welcomeTitle), findsOneWidget);
  });
}
