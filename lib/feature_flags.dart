import 'package:flutter/material.dart';

/// Контроллер для хранения и обновления feature-флагов.
///
/// Может использоваться с любыми источниками: локально, Firebase, RemoteConfig и т.д.
class FeatureFlagsController extends ChangeNotifier {
  Map<String, bool> _flags;

  FeatureFlagsController([Map<String, bool>? initialFlags])
    : _flags = initialFlags ?? {};

  void setFlags(Map<String, bool> newFlags) {
    _flags = Map.from(newFlags);

    notifyListeners();
  }

  void updateFlag(String key, bool value) {
    _flags[key] = value;

    notifyListeners();
  }

  bool isEnabled(String key) => _flags[key] ?? false;

  Map<String, bool> get all => Map.unmodifiable(_flags);
}

/// InheritedNotifier обёртка, предоставляющая доступ к флагам через context.
@immutable
final class FeatureFlags extends InheritedNotifier<FeatureFlagsController> {
  const FeatureFlags({
    required FeatureFlagsController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static FeatureFlagsController of(BuildContext context) {
    final FeatureFlags? result = context
        .dependOnInheritedWidgetOfExactType<FeatureFlags>();

    assert(result != null, 'No FeatureFlags found in context');

    return result!.notifier!;
  }
}
