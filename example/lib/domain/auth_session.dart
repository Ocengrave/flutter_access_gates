final class AuthSession {
  final String userId;
  final Set<String> roles;
  final Set<String> permissions;
  final Set<String> features;

  const AuthSession({
    required this.userId,
    required this.roles,
    required this.permissions,
    required this.features,
  });

  bool hasRole(String role) => roles.contains(role);
  bool hasPermission(String permission) => permissions.contains(permission);
  bool isFeatureEnabled(String flag) => features.contains(flag);
}
