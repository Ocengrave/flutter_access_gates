import 'package:flutter/material.dart';
import '../flutter_access_gates.dart';

/// [PermissionGate] — UI-гейт для проверки наличия конкретного разрешения.
///
/// Используется для условного отображения элементов UI, если у пользователя есть нужный пермишен.
///
/// Пример:
/// ```dart
/// PermissionGate(
///   permission: 'settings.edit',
///   child: ElevatedButton(onPressed: ..., child: Text('Изменить настройки')),
/// )
/// ```
final class PermissionGate extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;
  final Widget? loading;

  const PermissionGate({
    required this.permission,
    required this.child,
    this.fallback,
    this.loading,
    super.key,
  });

  static bool _checkPermission(BuildContext context, String permission) {
    final AccessStrategy strategy = AccessStrategyProvider.of(context);

    return strategy.hasPermission(context, permission);
  }

  @override
  Widget build(BuildContext context) {
    return AccessGate<String>(
      input: permission,
      check: _checkPermission,
      fallback: fallback,
      loading: loading,
      child: child,
    );
  }
}
