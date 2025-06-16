import 'package:flutter/material.dart';

import 'access_context.dart';

/// [AccessContextProvider] — an [InheritedWidget] for exposing your custom [AccessContext] instance.
///
/// This allows widgets in the tree to access your app's authorization context,
/// independently of Flutter's [BuildContext]-based logic.
///
/// This is useful when using the new experimental `AccessContext` API,
/// especially in apps using BLoC, Riverpod, or manual DI.
///
/// Example usage:
/// ```dart
/// AccessContextProvider(
///   context: MySessionContext(),
///   child: MyApp(),
/// )
/// ```
///
/// To retrieve the context inside widgets:
/// ```dart
/// final context = AccessContextProvider.of(context);
/// final canEdit = context.hasPermission(MyPermission.edit);
/// ```
final class AccessContextProvider extends InheritedWidget {
  final AccessContext context;

  const AccessContextProvider({
    required this.context,
    required super.child,
    super.key,
  });

  static AccessContext of(BuildContext context) {
    final AccessContextProvider? provider = context
        .dependOnInheritedWidgetOfExactType<AccessContextProvider>();

    assert(provider != null, 'AccessContextProvider not found');

    return provider!.context;
  }

  @override
  bool updateShouldNotify(AccessContextProvider old) => old.context != context;
}
