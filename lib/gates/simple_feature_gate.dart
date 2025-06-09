import 'package:flutter/material.dart';

/// {@template simple_feature_gate}
/// [SimpleFeatureGate] — упрощённый UI-гейт доступа по feature-флагу.
///
/// Предназначен для использования с локальными или внешними источниками флагов (Map, YAML, RemoteConfig).
/// Не требует AccessStrategy и используется как самостоятельный виджет.
///
/// > ⚠️ Не рекомендуется для продвинутых production-приложений. Для полной системы доступа — используйте [FeatureGate] с [AccessStrategy].
///
/// ---
///
/// Пример:
/// ```dart
/// SimpleFeatureGate(
///   flags: {'dev_mode': true},
///   flag: 'dev_mode',
///   child: DevPanel(),
///   fallback: Placeholder(),
/// )
/// ```
/// {@endtemplate}
@immutable
final class SimpleFeatureGate extends StatelessWidget {
  /// Карта активных флагов
  final Map<String, bool> flags;

  /// Название проверяемого флага
  final String flag;

  /// Виджет, если флаг активен
  final Widget child;

  /// Виджет при отключённом флаге
  final Widget fallback;

  const SimpleFeatureGate({
    required this.flags,
    required this.flag,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return flags[flag] == true ? child : fallback;
  }
}
