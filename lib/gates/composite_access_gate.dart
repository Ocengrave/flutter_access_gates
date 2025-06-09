import 'package:flutter/material.dart';

import '../flutter_access_gates.dart';

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
final class CompositeAccessGate extends StatelessWidget {
  final List<bool Function(BuildContext)> conditions;
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

  static bool _checkAll(
    BuildContext context,
    List<bool Function(BuildContext)> checks,
  ) {
    return checks.every((fn) => fn(context));
  }

  @override
  Widget build(BuildContext context) {
    return AccessGate<List<bool Function(BuildContext)>>(
      input: conditions,
      check: _checkAll,
      fallback: fallback,
      loading: loading,
      child: child,
    );
  }
}
