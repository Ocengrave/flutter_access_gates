import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/gates/context_access_gate.dart';
import 'package:flutter_access_gates/adapters/access_context.dart';

enum Role { admin, user }

final class MockContext implements AccessContext<Role, String, String> {
  final bool allow;

  MockContext(this.allow);

  @override
  bool hasPermission(String permission) => allow;

  @override
  bool hasRole(Role role) => allow;

  @override
  bool isFeatureEnabled(String flag) => allow;
}

void main() {
  group('ContextAccessGate', () {
    testWidgets('renders child when allowed (sync)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContextAccessGate(
            context: MockContext(true),
            allow: (ctx) => ctx.hasPermission('edit'),
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });

    testWidgets('renders fallback when not allowed (sync)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContextAccessGate(
            context: MockContext(false),
            allow: (ctx) => ctx.hasPermission('edit'),
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Denied'), findsOneWidget);
      expect(find.text('Allowed'), findsNothing);
    });

    testWidgets('renders child after async allowed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContextAccessGate(
            context: MockContext(true),
            allow: (ctx) async => Future.delayed(
              const Duration(milliseconds: 10),
              () => ctx.hasRole(Role.admin),
            ),
            loading: const Text('Loading...'),
            fallback: const Text('Denied'),
            child: const Text('Async Allowed'),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text('Async Allowed'), findsOneWidget);
    });

    testWidgets('renders fallback after async denied', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContextAccessGate(
            context: MockContext(false),
            allow: (ctx) async => Future.delayed(
              const Duration(milliseconds: 10),
              () => ctx.hasPermission('edit'),
            ),
            fallback: const Text('Async Denied'),
            child: const Text('Should Not See'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Async Denied'), findsOneWidget);
    });
  });
}
