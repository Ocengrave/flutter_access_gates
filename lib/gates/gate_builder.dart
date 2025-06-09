import 'package:flutter/material.dart';

/// {@template gate_ui_builder}
/// [GateUiBuilder] — синхронный контроллер доступа с произвольной логикой.
///
/// Используется в случаях, когда стандартные гейты (`PermissionGate`, `RoleGate`, `FeatureGate`)
/// не покрывают необходимые условия:
///
/// - сложные выражения: `user.isAdmin && region == 'KZ'`
/// - временные или контекстные условия
/// - отладочные/экспериментальные фичи
///
/// ⚠️ Не поддерживает асинхронные проверки!
///
/// > Если вам нужно условие `Future<bool>`, используйте `AccessGate<T>`.
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
/// {@endtemplate}
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
