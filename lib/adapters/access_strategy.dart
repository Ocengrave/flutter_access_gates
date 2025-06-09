import 'package:flutter/material.dart';

/// [AccessStrategy] — абстрактный контракт для источника данных доступа.
///
/// Используется внутри Gate-виджетов для проверки флагов, ролей, пермишенов и т.д.
@immutable
abstract class AccessStrategy {
  /// Проверка пермишена (например, 'orders.edit')
  bool hasPermission(BuildContext context, String permission);

  /// Проверка feature-флага (например, 'new_ui')
  bool isFeatureEnabled(BuildContext context, String flag);

  /// Проверка роли (если используется)
  bool hasRole(BuildContext context, String role);
}
