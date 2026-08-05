import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxa/components/otp_input.dart';

Future<void> _pump(WidgetTester tester, ValueChanged<String> onChanged) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: OtpInput(length: 5, onChanged: onChanged),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('typing advances through the boxes', (WidgetTester tester) async {
    String code = '';
    await _pump(tester, (String v) => code = v);

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.pump();

    expect(code, '12');
  });

  testWidgets('only digits are accepted', (WidgetTester tester) async {
    String code = '';
    await _pump(tester, (String v) => code = v);

    await tester.enterText(find.byType(TextField).at(0), 'a');
    await tester.pump();

    expect(code, isEmpty);
  });

  testWidgets('a full code reports every digit', (WidgetTester tester) async {
    String code = '';
    await _pump(tester, (String v) => code = v);

    for (int i = 0; i < 5; i++) {
      await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
      await tester.pump();
    }

    expect(code, '12345');
  });
}
