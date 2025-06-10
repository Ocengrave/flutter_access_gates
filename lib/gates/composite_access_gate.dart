import 'dart:async';

import 'package:flutter/material.dart';

typedef AccessCondition = FutureOr<bool> Function(BuildContext);

/// [CompositeAccessGate] — универсальный контроллер доступа, объединяющий несколько условий.
///
/// Показывает [child], если **все** функции-проверки возвращают `true`.
///
/// Пример:
/// ```dart
/// CompositeAccessGate(
///   conditions: [
///     (ctx) => ctx.read<Session>().hasRole('logist'),
///     (ctx) => ctx.read<Permissions>().has('edit_flight'),
///   ],
///   child: ElevatedButton(...),
///   fallback: const Text('Denied'),
/// );
/// ```
///
final class CompositeAccessGate extends StatelessWidget {
  final List<AccessCondition> conditions;
  final Widget child;
  final Widget? fallback;
  final Widget? loading;

  const CompositeAccessGate({
    required this.conditions,
    required this.child,
    this.fallback,
    this.loading,
    super.key,
  });

  Future<bool> _checkAllAsync(BuildContext context) {
    return Future.wait<bool>(
      conditions.map((fn) => Future.value(fn(context))),
    ).then((results) => results.every((r) => r));
  }

  @override
  Widget build(BuildContext context) {
    List<FutureOr<bool>> rawResults = <FutureOr<bool>>[];

    bool hasAsync = false;

    for (var fn in conditions) {
      final FutureOr<bool> res = fn(context);

      rawResults.add(res);

      if (res is Future<bool>) {
        hasAsync = true;
      }
    }

    // Все синхронно — можно сразу отрисовать
    if (hasAsync == false) {
      final bool allowed = rawResults.cast<bool>().every((r) => r);

      return allowed == true ? child : (fallback ?? const SizedBox.shrink());
    }

    return FutureBuilder<bool>(
      future: _checkAllAsync(context),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }

        if (snap.hasData == true && snap.data == true) {
          return child;
        }

        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}
