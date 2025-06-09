import 'dart:async';
import 'package:flutter/material.dart';

typedef AccessCheck<T> = FutureOr<bool> Function(BuildContext context, T input);

/// Универсальный асинхронный AccessGate, поддерживает как sync, так и async проверки.
///
/// Пример:
/// ```dart
/// AccessGate<String>(
///   input: 'edit',
///   check: (context, permission) {
///     return AccessStrategyProvider.of(context).hasPermission(context, permission);
///   },
///   child: Text('Access granted'),
///   fallback: Text('Access denied'),
/// )
/// ```
class AccessGate<T> extends StatefulWidget {
  final T input;
  final AccessCheck<T> check;
  final Widget child;
  final Widget? fallback;
  final Widget? loading;

  const AccessGate({
    required this.input,
    required this.check,
    required this.child,
    this.fallback,
    this.loading,
    super.key,
  });

  @override
  State<AccessGate<T>> createState() => _AccessGateState<T>();
}

final class _AccessGateState<T> extends State<AccessGate<T>> {
  bool? granted;

  void _resolveAccess() {
    setState(() => granted = null);
    Future.value(widget.check(context, widget.input))
        .then((value) {
          if (mounted) setState(() => granted = value);
        })
        .catchError((_) {
          if (mounted) setState(() => granted = false);
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveAccess();
  }

  @override
  void didUpdateWidget(covariant AccessGate<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.input != widget.input) {
      _resolveAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (granted == null) return widget.loading ?? const SizedBox.shrink();
    return granted! ? widget.child : widget.fallback ?? const SizedBox.shrink();
  }
}
