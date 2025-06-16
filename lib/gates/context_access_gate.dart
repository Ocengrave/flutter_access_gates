import 'dart:async';
import 'package:flutter/material.dart';
import '../adapters/access_context.dart';

typedef ContextAccessCondition = FutureOr<bool> Function(AccessContext);
typedef ContextAccessBuilder =
    Widget Function(BuildContext context, bool allowed);

/// A universal access gate widget that operates on an [AccessContext] instance,
/// allowing both sync and async permission checks.
///
/// Displays [child] if the provided [allow] condition returns `true`,
/// otherwise shows [fallback] or hides the widget.
///
/// ### Basic usage:
/// ```dart
/// ContextAccessGate(
///   context: MyAccessContext(),
///   allow: (ctx) => ctx.hasRole('admin'),
///   child: Text('Access granted'),
///   fallback: Text('Access denied'),
/// )
/// ```
///
/// ### With builder:
/// ```dart
/// ContextAccessGate(
///   context: MyAccessContext(),
///   allow: (ctx) => ctx.isFeatureEnabled('dark_mode'),
///   builder: (context, allowed) => Icon(
///     allowed ? Icons.check : Icons.block,
///   ),
/// )
/// ```
///
/// ### With async conditions:
/// ```dart
/// ContextAccessGate(
///   context: MyAccessContext(),
///   allow: (ctx) async => await ctx.hasPermission('edit'),
///   loading: CircularProgressIndicator(),
///   child: Text('Allowed'),
/// )
/// ```
///
/// ### Optional callbacks:
/// - [onAllow]: Called when access is granted
/// - [onDeny]: Called when access is denied
/// - [onError]: Called on exception during evaluation
///
/// This gate is context-agnostic and ideal for non-UI driven access models (e.g., BLoC, Riverpod, pure DI).
final class ContextAccessGate extends StatelessWidget {
  final AccessContext context;
  final ContextAccessCondition allow;

  final Widget? child;
  final Widget? fallback;
  final Widget? loading;
  final ContextAccessBuilder? builder;

  final VoidCallback? onAllow;
  final VoidCallback? onDeny;
  final void Function(Object error)? onError;

  const ContextAccessGate({
    required this.context,
    required this.allow,
    this.child,
    this.fallback,
    this.loading,
    this.builder,
    this.onAllow,
    this.onDeny,
    this.onError,
    super.key,
  });

  Future<bool> _evaluate() async {
    final result = await Future.value(allow(context));
    return result;
  }

  @override
  Widget build(BuildContext ctx) {
    final result = allow(context);

    if (result is bool) {
      final allowed = result;

      if (allowed) {
        onAllow?.call();
      } else {
        onDeny?.call();
      }

      return builder != null
          ? builder!(ctx, allowed)
          : (allowed ? child! : (fallback ?? const SizedBox.shrink()));
    }

    return FutureBuilder<bool>(
      future: _evaluate(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          onError?.call(snap.error!);
          return fallback ?? const SizedBox.shrink();
        }

        final allowed = snap.data == true;

        if (allowed) {
          onAllow?.call();
        } else {
          onDeny?.call();
        }

        return builder != null
            ? builder!(context, allowed)
            : (allowed ? child! : (fallback ?? const SizedBox.shrink()));
      },
    );
  }
}
