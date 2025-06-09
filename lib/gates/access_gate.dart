import 'package:flutter/material.dart';

/// [AccessGate] — абстрактный базовый класс для всех UI-контроллеров доступа.
///
/// Используется как основа для `PermissionGate`, `FeatureGate`, `CompositeAccessGate`, и т.п.
///
/// Реализует общую сигнатуру:
/// - `buildGranted` — виджет при разрешённом доступе
/// - `buildDenied` — виджет при отказе (по умолчанию `SizedBox.shrink()`)
///
/// Пример:
/// ```dart
/// final class MyCustomGate extends AccessGate {
///   const MyCustomGate({required super.child});
///
///   @override
///   Widget build(BuildContext context) {
///     final access = someCondition();
///     return access ? buildGranted(context) : buildDenied(context);
///   }
///
///   @override
///   Widget buildGranted(BuildContext context) => child;
/// }
/// ```
@immutable
abstract class AccessGate extends StatelessWidget {
  /// Виджет, отображаемый при успешной проверке доступа
  final Widget child;

  /// Виджет, отображаемый при отказе доступа (по умолчанию `null`)
  final Widget? fallback;

  const AccessGate({required this.child, this.fallback, super.key});

  /// Вызывается при успешной проверке доступа
  @protected
  Widget buildGranted(BuildContext context);

  /// Вызывается при отказе доступа (по умолчанию: `SizedBox.shrink()`)
  @protected
  Widget buildDenied(BuildContext context) =>
      fallback ?? const SizedBox.shrink();
}
