import 'dart:async';
import 'package:flutter/material.dart';

/// A function that returns whether access is granted based on the given [BuildContext].
typedef AccessCondition = FutureOr<bool> Function(BuildContext);

/// A builder function that renders a widget based on the access result.
typedef AccessGateBuilder = Widget Function(BuildContext context, bool allowed);

/// Determines how multiple access conditions are evaluated.
enum CompositeVariant {
  /// All conditions must return `true`.
  all,

  /// At least one condition must return `true`.
  any,

  /// All conditions must return `false`.
  none,

  /// A minimum number of conditions must return `true`.
  atLeast,
}

/// A flexible access gate that evaluates a list of [conditions] and displays widgets
/// based on the evaluation strategy defined by [variant].
///
/// Supports both sync and async conditions. Conditions can be evaluated using:
/// - `CompositeAccessGate` (default: `all`)
/// - `CompositeAccessGate.any`
/// - `CompositeAccessGate.none`
/// - `CompositeAccessGate.atLeast`
/// - `CompositeAccessGate.builder` for full custom rendering
///
/// ## Example
/// ```dart
/// CompositeAccessGate.any(
///   conditions: [
///     (ctx) => user.hasRole('admin'),
///     (ctx) => user.hasPermission('view'),
///   ],
///   child: Text('Access granted'),
///   fallback: Text('Access denied'),
/// )
/// ```
///
/// Supports `onAllow`, `onDeny`, `onError` callbacks, a debug mode, and async loading state.
final class CompositeAccessGate extends StatelessWidget {
  /// List of conditions to evaluate. Can be synchronous or asynchronous.
  final List<AccessCondition> conditions;

  /// Widget to render if access is granted.
  final Widget? child;

  /// Widget to render if access is denied.
  final Widget? fallback;

  /// Widget to render while async conditions are still being evaluated.
  final Widget? loading;

  /// Evaluation strategy: all/any/none/atLeast
  final CompositeVariant variant;

  /// Used with [CompositeVariant.atLeast] to define how many `true` conditions are required.
  final int? atLeastCount;

  /// Enables debug logging of evaluation steps.
  final bool debug;

  /// Called once if access is granted.
  final void Function()? onAllow;

  /// Called once if access is denied.
  final void Function()? onDeny;

  /// Called if any condition throws an error.
  final void Function(Object error)? onError;

  /// A custom builder that receives the final access decision.
  final AccessGateBuilder? builder;

  /// Default constructor: all conditions must return true.
  const CompositeAccessGate({
    required this.conditions,
    required Widget this.child,
    this.fallback,
    this.loading,
    this.debug = false,
    this.onAllow,
    this.onDeny,
    this.onError,
    super.key,
  }) : builder = null,
       variant = CompositeVariant.all,
       atLeastCount = null;

  /// Requires at least one condition to return true.
  const CompositeAccessGate.any({
    required this.conditions,
    required Widget this.child,
    this.fallback,
    this.loading,
    this.debug = false,
    this.onAllow,
    this.onDeny,
    this.onError,
    super.key,
  }) : builder = null,
       variant = CompositeVariant.any,
       atLeastCount = null;

  /// Requires all conditions to return false.
  const CompositeAccessGate.none({
    required this.conditions,
    required Widget this.child,
    this.fallback,
    this.loading,
    this.debug = false,
    this.onAllow,
    this.onDeny,
    this.onError,
    super.key,
  }) : builder = null,
       variant = CompositeVariant.none,
       atLeastCount = null;

  /// Requires at least [atLeastCount] conditions to return true.
  const CompositeAccessGate.atLeast({
    required this.conditions,
    required this.atLeastCount,
    required Widget this.child,
    this.fallback,
    this.loading,
    this.debug = false,
    this.onAllow,
    this.onDeny,
    this.onError,
    super.key,
  }) : builder = null,
       variant = CompositeVariant.atLeast;

  /// Custom builder constructor. Allows full control over rendering based on access result.
  const CompositeAccessGate.builder({
    required this.conditions,
    required this.builder,
    this.loading,
    this.debug = false,
    this.onAllow,
    this.onDeny,
    this.onError,
    this.variant = CompositeVariant.all,
    this.atLeastCount,
    super.key,
  }) : child = null,
       fallback = null;

  bool _evaluate(List<bool> results) {
    if (debug == true) {
      debugPrint('[CompositeAccessGate] Variant: $variant');

      for (var i = 0; i < results.length; i++) {
        debugPrint('[Condition $i] Result: ${results[i]}');
      }
    }

    final result = switch (variant) {
      CompositeVariant.all => results.every((r) => r),
      CompositeVariant.any => results.any((r) => r),
      CompositeVariant.none => results.every((r) => !r),
      CompositeVariant.atLeast =>
        results.where((r) => r).length >= (atLeastCount ?? 1),
    };

    if (debug == true) {
      debugPrint('[CompositeAccessGate] Final decision: $result');
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<FutureOr<bool>> rawResults = conditions
        .map((fn) => fn(context))
        .toList();

    final bool hasAsync = rawResults.any((r) => r is Future<bool>);

    if (hasAsync == false) {
      final bool allowed = _evaluate(rawResults.cast<bool>());

      if (allowed == true) {
        onAllow?.call();
      } else {
        onDeny?.call();
      }

      return builder != null
          ? builder!(context, allowed)
          : (allowed ? child! : (fallback ?? const SizedBox.shrink()));
    }

    return FutureBuilder<List<bool>>(
      future: Future.wait(rawResults.map(Future.value)),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError == true) {
          onError?.call(snap.error!);

          return fallback ?? const SizedBox.shrink();
        }

        final List<bool> results = snap.data ?? [];

        final bool allowed = _evaluate(results);

        if (allowed == true) {
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
