import 'package:flutter/material.dart';
import 'access_gate.dart';
import '../feature_flags.dart';

/// {@template feature_gate}
/// [FeatureGate] — контроллер доступа по feature-флагу.
///
/// Отображает [child], если заданный флаг активен, иначе — [fallback].
///
/// Используется для:
/// - постепенного выката фич
/// - A/B тестов
/// - временного скрытия UI-компонентов
///
/// Работает в паре с [FeatureFlagsController], который должен быть
/// обернут через [FeatureFlags] на уровне `MaterialApp`.
///
/// Пример:
/// ```dart
/// FeatureGate(
///   flag: 'new_ui',
///   child: NewUIWidget(),
/// )
/// ```
/// {@endtemplate}
@immutable
final class FeatureGate extends AccessGate {
  /// Имя feature-флага
  final String flag;

  /// Виджет, если флаг активен
  const FeatureGate({
    required this.flag,
    required super.child,
    super.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FeatureFlagsController flags = FeatureFlags.of(context);

    final bool isEnabled = flags.isEnabled(flag);

    return isEnabled == true ? buildGranted(context) : buildDenied(context);
  }

  @override
  Widget buildGranted(BuildContext context) => child;
}
