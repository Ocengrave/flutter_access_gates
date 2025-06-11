import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_access_gates_example/infrastructure/session_access_strategy.dart';
import 'package:flutter_access_gates_example/infrastructure/auth_session_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthSessionProvider(),
      child: const ProviderExampleApp(),
    ),
  );
}

final class ProviderExampleApp extends StatelessWidget {
  const ProviderExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthSessionProvider auth = Provider.of<AuthSessionProvider>(context);

    if (auth.isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (auth.hasError == true || auth.session == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('❌ Error loading session')),
        ),
      );
    }

    final session = auth.session!;

    return FeatureFlags(
      controller: FeatureFlagsController(
        {for (final flag in session.features) flag: true},
      ),
      child: AccessStrategyProvider(
        strategy: SessionAccessStrategy(session),
        child: MaterialApp(
          theme: ThemeData.light(),
          home: const ProviderExamplePage(),
        ),
      ),
    );
  }
}

final class ProviderExamplePage extends StatelessWidget {
  const ProviderExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Example')),
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
    );
  }
}
