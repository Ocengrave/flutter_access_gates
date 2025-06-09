import 'package:flutter/material.dart';
import '../feature_flags.dart';
import 'access_strategy.dart';

/// [FeatureFlagsStrategyAdapter] — адаптер `AccessStrategy`, основанный на [FeatureFlagsController].
///
/// Используется, если нужно использовать `FeatureGate` через общую стратегию доступа.
@immutable
final class FeatureFlagsStrategyAdapter implements AccessStrategy {
  @override
  bool hasPermission(BuildContext context, String permission) {
    // Пустая реализация — используется только фичи
    return false;
  }

  @override
  bool hasRole(BuildContext context, String role) {
    // Пустая реализация — используется только фичи
    return false;
  }

  @override
  bool isFeatureEnabled(BuildContext context, String flag) {
    return FeatureFlags.of(context).isEnabled(flag);
  }
}
