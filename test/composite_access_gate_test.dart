import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/gates/composite_access_gate.dart';

void main() {
  group('CompositeGate', () {
    testWidgets('shows child if all conditions are true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [(_) => true, (_) => true],
            child: const Text('Visible'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Visible'), findsOneWidget);
    });

    testWidgets('shows fallback if any condition is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [(_) => true, (_) => false],
            fallback: const Text('Denied'),
            child: const Text('Should Not Be Visible'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Should Not Be Visible'), findsNothing);
      expect(find.text('Denied'), findsOneWidget);
    });

    testWidgets('shows fallback if all conditions are false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [(_) => false, (_) => false],
            fallback: const Text('Denied'),
            child: const Text('Should Not Be Visible'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Should Not Be Visible'), findsNothing);
      expect(find.text('Denied'), findsOneWidget);
    });

    testWidgets('shows child if conditions list is empty (default true)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [],
            child: const Text('Visible by default'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Visible by default'), findsOneWidget);
    });
  });
}
