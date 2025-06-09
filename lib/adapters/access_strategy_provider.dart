import 'package:flutter/widgets.dart';
import 'access_strategy.dart';

/// [AccessStrategyProvider] — InheritedWidget для внедрения кастомной [AccessStrategy].
///
/// Используется в `main.dart` или на уровне AppShell.
/// Пример:
/// ```dart
/// AccessStrategyProvider(
///   strategy: ProviderAccessStrategy(),
///   child: MyApp(),
/// )
/// ```
@immutable
final class AccessStrategyProvider extends InheritedWidget {
  final AccessStrategy strategy;

  const AccessStrategyProvider({
    required this.strategy,
    required super.child,
    super.key,
  });

  static AccessStrategy of(BuildContext context) {
    final AccessStrategyProvider? provider = context
        .dependOnInheritedWidgetOfExactType<AccessStrategyProvider>();

    assert(provider != null, 'AccessStrategyProvider not found in widget tree');

    return provider!.strategy;
  }

  @override
  bool updateShouldNotify(covariant AccessStrategyProvider oldWidget) {
    return oldWidget.strategy != strategy;
  }
}
