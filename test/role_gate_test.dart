import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'support/fake_access_strategy.dart';

void main() {
  testWidgets('RoleGate shows child if role granted', (tester) async {
    await tester.pumpWidget(
      AccessStrategyProvider(
        strategy: FakeAccessStrategy(allowedRoles: {'admin'}),
        child: MaterialApp(
          home: RoleGate(role: 'admin', child: Text('Welcome Admin')),
        ),
      ),
    );

    expect(find.text('Welcome Admin'), findsOneWidget);
  });

  testWidgets('RoleGate hides child if role denied', (tester) async {
    await tester.pumpWidget(
      AccessStrategyProvider(
        strategy: FakeAccessStrategy(allowedRoles: {'user'}),
        child: MaterialApp(
          home: RoleGate(role: 'admin', child: Text('Restricted Area')),
        ),
      ),
    );

    expect(find.text('Restricted Area'), findsNothing);
  });
}
