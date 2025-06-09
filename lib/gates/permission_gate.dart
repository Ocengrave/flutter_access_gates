import 'package:flutter/material.dart';
import 'access_gate.dart';
import '../adapters/access_strategy.dart';
import '../adapters/access_strategy_provider.dart';

/// [PermissionGate] — UI-гейт для проверки наличия конкретного разрешения.
///
/// Используется для условного отображения элементов UI, если у пользователя есть нужный пермишен.
///
/// Требует:
/// - Зарегистрированный [AccessStrategy] в дереве виджетов
///
/// ---
///
/// Пример:
/// ```dart
/// PermissionGate(
///   permission: 'settings.edit',
///   child: ElevatedButton(onPressed: ..., child: Text('Изменить настройки')),
/// )
/// ```
@immutable
final class PermissionGate extends AccessGate {
  /// Название разрешения, которое должен иметь пользователь
  final String permission;

  const PermissionGate({
    required this.permission,
    required super.child,
    super.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AccessStrategy strategy = AccessStrategyProvider.of(context);

    final bool isGranted = strategy.hasPermission(context, permission);

    return isGranted == true ? buildGranted(context) : buildDenied(context);
  }

  @override
  Widget buildGranted(BuildContext context) => child;
}
