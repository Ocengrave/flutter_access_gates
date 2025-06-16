/// [AccessContext] — a generic interface for access evaluation.
///
/// This interface abstracts permission, role, and feature flag checks
/// away from the Flutter [BuildContext], enabling usage in DI layers,
/// BLoC, Riverpod, or anywhere outside the widget tree.
///
/// Type parameters:
/// - [R] — Role type (e.g., `String`, `enum Role`)
/// - [P] — Permission type (e.g., `String`, `enum Permission`)
/// - [F] — Feature flag type (e.g., `String`, `enum FeatureFlag`)
///
/// Example:
/// ```dart
/// final class SessionContext implements AccessContext<Role, Permission, FeatureFlag> {
///   ...
/// }
/// ```
abstract interface class AccessContext<R, P, F> {
  /// Returns `true` if the user has the specified role.
  bool hasRole(R role);

  /// Returns `true` if the user has the specified permission.
  bool hasPermission(P permission);

  /// Returns `true` if the specified feature flag is enabled.
  bool isFeatureEnabled(F flag);
}
