import 'package:flutter/material.dart';
import 'access_strategy.dart';

/// {@template multi_access_strategy}
/// [MultiAccessStrategy] — композиция из нескольких [AccessStrategy].
///
/// Применяется, когда логика доступа разбита по нескольким источникам:
/// - локальная стратегия (например, мок или кэш)
/// - внешняя стратегия (например, из API, Firebase, Auth0)
/// - временные заглушки
///
/// Проверка (`hasPermission`, `hasRole`, `isFeatureEnabled`) возвращает `true`,
/// если **хотя бы одна** из стратегий даёт положительный ответ.
///
/// Используется по принципу **"хоть кто-то разрешил — значит доступ есть"**.
///
/// ---
///
/// Пример:
/// ```dart
/// MultiAccessStrategy([
///   LocalMockStrategy(),
///   FirebasePermissionsStrategy(),
/// ])
/// ```
/// {@endtemplate}
@immutable
final class MultiAccessStrategy implements AccessStrategy {
  /// Список стратегий, по которым выполняется проверка.
  final List<AccessStrategy> strategies;

  /// Создаёт объединённую стратегию доступа.
  const MultiAccessStrategy(this.strategies);

  @override
  bool hasPermission(BuildContext context, String permission) {
    for (final strategy in strategies) {
      if (strategy.hasPermission(context, permission)) return true;
    }

    return false;
  }

  @override
  bool hasRole(BuildContext context, String role) {
    for (final strategy in strategies) {
      if (strategy.hasRole(context, role)) return true;
    }

    return false;
  }

  @override
  bool isFeatureEnabled(BuildContext context, String flag) {
    for (final strategy in strategies) {
      if (strategy.isFeatureEnabled(context, flag)) return true;
    }

    return false;
  }
}
