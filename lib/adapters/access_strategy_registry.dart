import 'package:flutter/material.dart';

import 'access_strategy.dart';

@immutable
class AccessStrategyRegistry implements AccessStrategy {
  final AccessStrategy permissionStrategy;
  final AccessStrategy roleStrategy;
  final AccessStrategy featureStrategy;

  const AccessStrategyRegistry({
    required this.permissionStrategy,
    required this.roleStrategy,
    required this.featureStrategy,
  });

  @override
  bool hasPermission(BuildContext context, String permission) {
    return permissionStrategy.hasPermission(context, permission);
  }

  @override
  bool hasRole(BuildContext context, String role) {
    return roleStrategy.hasRole(context, role);
  }

  @override
  bool isFeatureEnabled(BuildContext context, String flag) {
    return featureStrategy.isFeatureEnabled(context, flag);
  }
}
