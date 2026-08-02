import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/app.dart';

void main() {
  testWidgets('app boots on the splash route', (WidgetTester tester) async {
    await tester.pumpWidget(const FluxaApp());
    await tester.pumpAndSettle();

    expect(find.text('Splash'), findsOneWidget);
  });
}
