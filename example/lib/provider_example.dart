import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_access_gates_example/infrastructure/session_access_strategy.dart';
import 'package:flutter_access_gates_example/infrastructure/auth_session_provider.dart';
import 'package:provider/provider.dart';

import 'domain/auth_session.dart';

final class ProviderExamplePage extends StatelessWidget {
  const ProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthSessionProvider>();

    if (auth.isLoading == true) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.hasError == true || auth.session == null) {
      return const Scaffold(
        body: Center(child: Text('❌ Error loading session')),
      );
    }

    final AuthSession session = auth.session!;

    return AccessStrategyProvider(
      strategy: SessionAccessStrategy(session),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const FeatureGate(
              flag: 'dev_mode',
              child: Text('FeatureGate: dev_mode'),
            ),
            const RoleGate(
              role: 'admin',
              child: Text('RoleGate: admin'),
            ),
            const PermissionGate(
              permission: 'edit',
              child: Text('PermissionGate: edit'),
            ),
            CompositeAccessGate(
              conditions: [
                (ctx) => AccessStrategyProvider.of(ctx).hasRole(ctx, 'admin'),
                (ctx) =>
                    AccessStrategyProvider.of(ctx).hasPermission(ctx, 'export'),
              ],
              child: const Text('🔐 Composite: admin + export'),
            ),
          ],
        ),
      ),
    );
  }
}
