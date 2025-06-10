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
  group('CompositeGate (async)', () {
    testWidgets('show loading, after show child when true async-condition', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [
              (_) async {
                await Future.delayed(const Duration(milliseconds: 50));
                return true;
              },
            ],
            loading: const Text('Loading...'),
            child: const Text('Async OK'),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Async OK'), findsNothing);

      await tester.pumpAndSettle();

      expect(find.text('Async OK'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('show fallback, at list one async-condition false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate(
            conditions: [(_) async => true, (_) async => false],
            loading: const Text('Loading...'),
            fallback: const Text('Denied async'),
            child: const Text('Should Not Appear'),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Denied async'), findsOneWidget);
      expect(find.text('Should Not Appear'), findsNothing);
      expect(find.text('Loading...'), findsNothing);
    });
  });
}
