import 'package:flutter/material.dart';
import 'access_gate.dart';

/// [CompositeGate] — универсальный контроллер доступа, объединяющий несколько условий.
///
/// Принимает список функций-проверок (от `BuildContext`), и если **все** возвращают `true`,
/// то отображается `child`, иначе — `buildDenied`.
///
/// Пример:
/// ```dart
/// CompositeGate(
///   conditions: [
///     (ctx) => ctx.read<Session>().hasRole('logist'),
///     (ctx) => ctx.read<Permissions>().has('edit_flight'),
///   ],
///   child: ElevatedButton(...),
///   fallback: const Text('Denied'),
/// );
/// ```
final class CompositeAccessGate extends AccessGate {
  final List<bool Function(BuildContext)> conditions;

  const CompositeAccessGate({
    required this.conditions,
    required super.child,
    super.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGranted = conditions.every((check) => check(context));

    return isGranted == true ? buildGranted(context) : buildDenied(context);
  }

  @override
  Widget buildGranted(BuildContext context) => child;
}
