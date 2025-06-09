import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GateUiBuilder', () {
    testWidgets('renders builder if condition is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GateUiBuilder(
            condition: (_) => true,
            builder: (_) => const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
    });

    testWidgets('renders denied if condition is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GateUiBuilder(
            condition: (_) => false,
            builder: (_) => const Text('Allowed'),
            denied: (_) => const Text('Denied'),
          ),
        ),
      );

      expect(find.text('Denied'), findsOneWidget);
      expect(find.text('Allowed'), findsNothing);
    });

    testWidgets(
      'renders SizedBox if denied is not provided and condition is false',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: GateUiBuilder(
              condition: (_) => false,
              builder: (_) => const Text('Allowed'),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.text('Allowed'), findsNothing);
      },
    );
  });
}
