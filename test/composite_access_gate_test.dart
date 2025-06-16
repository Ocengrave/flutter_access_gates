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

    testWidgets('any variant works if at least one is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate.any(
            conditions: [(_) => false, (_) => true],
            fallback: const Text('Fallback'),
            child: const Text('ANY success'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('ANY success'), findsOneWidget);
    });

    testWidgets('none variant hides if any true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate.none(
            conditions: [(_) => false, (_) => true],
            fallback: const Text('NONE passed'),
            child: const Text('Should not see'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('NONE passed'), findsOneWidget);
    });

    testWidgets('atLeast variant passes if threshold met', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate.atLeast(
            atLeastCount: 2,
            conditions: [(_) => true, (_) => true, (_) => false],
            fallback: const Text('Not enough'),
            child: const Text('At least passed'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('At least passed'), findsOneWidget);
    });

    testWidgets('calls builder with correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate.builder(
            conditions: [(_) => true, (_) => false],
            builder: (ctx, allowed) => Text(allowed ? 'Allowed' : 'Denied'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Denied'), findsOneWidget);
    });

    testWidgets('calls onAllow / onDeny callbacks', (tester) async {
      bool allowedCalled = false;
      bool deniedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CompositeAccessGate.any(
            conditions: [(_) => true],
            child: const Text('Visible'),
            onAllow: () => allowedCalled = true,
            onDeny: () => deniedCalled = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(allowedCalled, isTrue);
      expect(deniedCalled, isFalse);
    });
  });
}
