import 'package:flutter/material.dart';
import 'package:flutter_access_gates/adapters/access_strategy.dart';
import 'package:flutter_access_gates_example/domain/auth_session.dart';

final class SessionAccessStrategy implements AccessStrategy {
  final AuthSession session;
  const SessionAccessStrategy(this.session);

  @override
  bool hasPermission(BuildContext context, String permission) =>
      session.hasPermission(permission);

  @override
  bool hasRole(BuildContext context, String role) => session.hasRole(role);

  @override
  bool isFeatureEnabled(BuildContext context, String flag) =>
      session.isFeatureEnabled(flag);
}
