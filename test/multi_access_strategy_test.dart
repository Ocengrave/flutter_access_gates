import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';

import 'support/fake_access_strategy.dart';

void main() {
  group('MultiAccessStrategy', () {
    testWidgets('grants permission if any strategy grants it', (tester) async {
      final strategy = MultiAccessStrategy([
        const FakeAccessStrategy(allowedPermissions: {'x'}),
        const FakeAccessStrategy(allowedPermissions: {'test'}),
        const FakeAccessStrategy(),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = strategy.hasPermission(context, 'test');
              return Text('result:$result', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('result:true'), findsOneWidget);
    });

    testWidgets('denies permission if all strategies deny it', (tester) async {
      final strategy = MultiAccessStrategy([
        const FakeAccessStrategy(allowedPermissions: {'x'}),
        const FakeAccessStrategy(),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = strategy.hasPermission(context, 'test');
              return Text('result:$result', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('result:false'), findsOneWidget);
    });

    testWidgets('grants role if any strategy grants it', (tester) async {
      final strategy = MultiAccessStrategy([
        const FakeAccessStrategy(),
        const FakeAccessStrategy(allowedRoles: {'admin'}),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = strategy.hasRole(context, 'admin');
              return Text('role:$result', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('role:true'), findsOneWidget);
    });

    testWidgets('grants feature if any strategy enables it', (tester) async {
      final strategy = MultiAccessStrategy([
        const FakeAccessStrategy(),
        const FakeAccessStrategy(enabledFeatures: {'new_ui'}),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = strategy.isFeatureEnabled(context, 'new_ui');
              return Text('feature:$result', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(find.text('feature:true'), findsOneWidget);
    });
  });
}
