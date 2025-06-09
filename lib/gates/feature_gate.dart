import 'package:flutter/material.dart';
import '../flutter_access_gates.dart';

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
final class FeatureGate extends StatelessWidget {
  /// Имя feature-флага
  final String flag;

  /// Виджет при активном флаге
  final Widget child;

  /// Виджет при неактивном флаге
  final Widget? fallback;

  /// Виджет при загрузке
  final Widget? loading;

  /// {@macro feature_gate}
  const FeatureGate({
    required this.flag,
    required this.child,
    this.fallback,
    this.loading,
    super.key,
  });

  static bool _checkFlag(BuildContext context, String flag) {
    final FeatureFlagsController controller = FeatureFlags.of(context);
    return controller.isEnabled(flag);
  }

  @override
  Widget build(BuildContext context) {
    return AccessGate<String>(
      input: flag,
      check: _checkFlag,
      fallback: fallback,
      loading: loading,
      child: child,
    );
  }
}
