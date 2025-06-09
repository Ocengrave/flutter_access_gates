import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/adapters/access_strategy.dart';
import 'package:flutter_access_gates/adapters/access_strategy_provider.dart';

import 'support/fake_access_strategy.dart';

void main() {
  testWidgets('AccessStrategyProvider provides strategy to context', (
    tester,
  ) async {
    late AccessStrategy strategy;
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: AccessStrategyProvider(
          strategy: const FakeAccessStrategy(
            allowedPermissions: {'test'},
            allowedRoles: {'admin'},
          ),
          child: Builder(
            builder: (ctx) {
              context = ctx;
              strategy = AccessStrategyProvider.of(ctx);
              return const Placeholder();
            },
          ),
        ),
      ),
    );

    expect(strategy.hasPermission(context, 'test'), isTrue); // ✅ ok
    expect(strategy.hasPermission(context, 'denied'), isFalse); // ✅ ok
    expect(strategy.hasRole(context, 'admin'), isTrue); // ✅ ok
  });
}
