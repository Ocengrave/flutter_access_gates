import 'package:flutter/material.dart';
import 'package:flutter_access_gates/adapters/access_strategy.dart';
import 'access_gate.dart';
import '../adapters/access_strategy_provider.dart';

/// {@template role_gate}
/// [RoleGate] — декларативный контроллер доступа, отображающий [child]
/// только при наличии у пользователя заданной роли.
///
/// Используется, когда нужно ограничить доступ к части UI
/// в зависимости от ролей авторизованного пользователя.
///
///
/// Пример:
/// ```dart
/// RoleGate(
///   role: 'admin',
///   child: AdminPanel(),
/// )
/// ```
///
/// Для работы требует установленного [AccessStrategy] через [AccessStrategyProvider].
/// Обычно подключается в `main.dart`:
/// ```dart
/// AccessStrategyProvider(
///   strategy: ProviderAccessStrategy(),
///   child: MyApp(),
/// )
/// ```
///
/// Вместо ручных проверок:
/// ```dart
/// if (session.hasRole('admin')) return AdminPanel();
/// ```
///
/// Используйте:
/// ```dart
/// RoleGate(role: 'admin', child: AdminPanel())
/// ```
/// {@endtemplate}
@immutable
final class RoleGate extends AccessGate {
  /// {@macro role_gate}
  const RoleGate({
    required this.role,
    required super.child,
    super.fallback,
    super.key,
  });

  /// Название требуемой роли (например, `'admin'`, `'logist'`)
  final String role;

  @override
  Widget build(BuildContext context) {
    final AccessStrategy strategy = AccessStrategyProvider.of(context);

    final bool isGranted = strategy.hasRole(context, role);

    return isGranted == true ? buildGranted(context) : buildDenied(context);
  }

  @override
  Widget buildGranted(BuildContext context) => child;
}
