import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// [DebugGate] — UI-гейт, отображающий [child] **только в debug-сборке**.
///
/// Позволяет безопасно рендерить отладочные элементы интерфейса,
/// исключённые из production.
///
/// По умолчанию, при `!kDebugMode`, возвращает `SizedBox.shrink()`.
///
/// Пример:
/// ```dart
/// DebugGate(
///   child: DevPanel(),
/// )
/// ```
final class DebugGate extends StatelessWidget {
  /// Виджет, отображаемый в debug-сборке
  final Widget child;

  /// Виджет, отображаемый в релизе (по умолчанию пустой)
  final Widget fallback;

  const DebugGate({
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kDebugMode == true ? child : fallback;
  }
}
