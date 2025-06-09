import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'support/fake_access_strategy.dart';

void main() {
  testWidgets('PermissionGate shows child if permission granted', (
    tester,
  ) async {
    await tester.pumpWidget(
      AccessStrategyProvider(
        strategy: FakeAccessStrategy(allowedPermissions: {'allowed'}),
        child: MaterialApp(
          home: PermissionGate(permission: 'allowed', child: Text('Visible')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Visible'), findsOneWidget);
  });

  testWidgets('PermissionGate hides child if permission denied', (
    tester,
  ) async {
    await tester.pumpWidget(
      AccessStrategyProvider(
        strategy: FakeAccessStrategy(allowedPermissions: {'something_else'}),
        child: MaterialApp(
          home: PermissionGate(permission: 'denied', child: Text('Hidden')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hidden'), findsNothing);
  });
}
