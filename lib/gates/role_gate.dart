import 'package:flutter/material.dart';
import '../flutter_access_gates.dart';

/// {@template role_gate}
/// [RoleGate] — декларативный контроллер доступа, отображающий [child]
/// только при наличии у пользователя заданной роли.
///
/// Используется, когда нужно ограничить доступ к части UI
/// в зависимости от ролей авторизованного пользователя.
///
/// Пример:
/// ```dart
/// RoleGate(role: 'admin', child: AdminPanel())
/// ```
/// {@endtemplate}
final class RoleGate extends StatelessWidget {
  final String role;
  final Widget child;
  final Widget? fallback;
  final Widget? loading;

  const RoleGate({
    required this.role,
    required this.child,
    this.fallback,
    this.loading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AccessGate<String>(
      input: role,
      check: _checkRole,
      fallback: fallback,
      loading: loading,
      child: child,
    );
  }

  static bool _checkRole(BuildContext context, String role) {
    final AccessStrategy strategy = AccessStrategyProvider.of(context);
    return strategy.hasRole(context, role);
  }
}
