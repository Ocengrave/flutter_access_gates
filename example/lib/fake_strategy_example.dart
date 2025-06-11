import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';

void main() {
  runApp(const FakeStrategyExampleApp());
}

final class FakeStrategyExampleApp extends StatelessWidget {
  const FakeStrategyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureFlags(
      controller: FeatureFlagsController({
        'dev_mode': true,
        'beta_ui': true,
      }),
      child: AccessStrategyProvider(
        strategy: const FakeAccessStrategy(
          allowedRoles: {'admin'},
          allowedPermissions: {'edit', 'export'},
          enabledFeatures: {'dev_mode', 'beta_ui'},
        ),
        child: MaterialApp(
          theme: ThemeData.light(),
          home: const FakeStrategyPage(),
        ),
      ),
    );
  }
}

final class FakeStrategyPage extends StatelessWidget {
  const FakeStrategyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FakeStrategy Example')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const FeatureGate(
            flag: 'dev_mode',
            child: Text('✅ FeatureGate: dev_mode enabled'),
          ),
          const RoleGate(
            role: 'admin',
            child: Text('👑 RoleGate: admin'),
          ),
          const PermissionGate(
            permission: 'edit',
            child: Text('🛠 PermissionGate: edit'),
          ),
          CompositeAccessGate(
            conditions: [
              (ctx) => AccessStrategyProvider.of(ctx).hasRole(ctx, 'admin'),
              (ctx) =>
                  AccessStrategyProvider.of(ctx).hasPermission(ctx, 'export'),
            ],
            child: const Text('🔐 Composite: admin + export'),
          ),
          const DebugGate(
            fallback: Text('👀 DebugGate: fallback'),
            child: Text('🧪 DebugGate: debug only'),
          ),
        ],
      ),
    );
  }
}

final class FakeAccessStrategy implements AccessStrategy {
  final Set<String> allowedPermissions;
  final Set<String> allowedRoles;
  final Set<String> enabledFeatures;

  const FakeAccessStrategy({
    this.allowedPermissions = const {},
    this.allowedRoles = const {},
    this.enabledFeatures = const {},
  });

  @override
  bool hasPermission(BuildContext context, String permission) {
    return allowedPermissions.contains(permission);
  }

  @override
  bool hasRole(BuildContext context, String role) {
    return allowedRoles.contains(role);
  }

  @override
  bool isFeatureEnabled(BuildContext context, String flag) {
    return enabledFeatures.contains(flag);
  }
}
