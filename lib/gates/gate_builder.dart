import 'package:flutter/material.dart';

/// [GateUiBuilder] — универсальный контроллер доступа с кастомной логикой.
///
/// Используется в случаях, когда стандартные гейты (`PermissionGate`, `RoleGate`, `FeatureGate`)
/// не покрывают необходимую проверку:
///
/// - сложные выражения: `user.isAdmin && region == 'KZ'`
/// - временные условия, ограничения по дате
/// - отладочные/экспериментальные фичи
///
/// > В большинстве случаев предпочтительнее использовать специализированные гейты
///
/// ---
///
/// Пример:
/// ```dart
/// GateUiBuilder(
///   condition: (context) {
///     final session = context.read<AuthSession>();
///     return session.hasPermission('debug.view') && !session.isExpired;
///   },
///   builder: (context) => DebugPanel(),
/// )
/// ```
@immutable
final class GateUiBuilder extends StatelessWidget {
  /// Условие: возвращает `true`, если доступ разрешён
  final bool Function(BuildContext context) condition;

  /// Виджет, отображаемый при успешной проверке
  final WidgetBuilder builder;

  /// Виджет при отказе доступа (по умолчанию: `SizedBox.shrink()`)
  final WidgetBuilder? denied;

  const GateUiBuilder({
    required this.condition,
    required this.builder,
    this.denied,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool granted = condition(context);

    return granted == true
        ? builder(context)
        : denied?.call(context) ?? const SizedBox.shrink();
  }
}
