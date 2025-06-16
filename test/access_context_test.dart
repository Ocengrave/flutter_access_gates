import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/adapters/access_context.dart';

enum Role { admin, user }

enum Permission { edit, export }

enum FeatureFlag { darkMode, beta }

class FakeAccessContext
    implements AccessContext<Role, Permission, FeatureFlag> {
  final Set<Role> roles;
  final Set<Permission> permissions;
  final Set<FeatureFlag> features;

  FakeAccessContext({
    required this.roles,
    required this.permissions,
    required this.features,
  });

  @override
  bool hasPermission(Permission permission) => permissions.contains(permission);

  @override
  bool hasRole(Role role) => roles.contains(role);

  @override
  bool isFeatureEnabled(FeatureFlag flag) => features.contains(flag);
}

void main() {
  group('AccessContext', () {
    test('should return true if permission exists', () {
      final ctx = FakeAccessContext(
        roles: {Role.admin},
        permissions: {Permission.edit},
        features: {FeatureFlag.darkMode},
      );

      expect(ctx.hasPermission(Permission.edit), isTrue);
      expect(ctx.hasPermission(Permission.export), isFalse);
    });

    test('should return true if role exists', () {
      final ctx = FakeAccessContext(
        roles: {Role.admin},
        permissions: {},
        features: {},
      );

      expect(ctx.hasRole(Role.admin), isTrue);
      expect(ctx.hasRole(Role.user), isFalse);
    });

    test('should return true if feature is enabled', () {
      final ctx = FakeAccessContext(
        roles: {},
        permissions: {},
        features: {FeatureFlag.beta},
      );

      expect(ctx.isFeatureEnabled(FeatureFlag.beta), isTrue);
      expect(ctx.isFeatureEnabled(FeatureFlag.darkMode), isFalse);
    });
  });
}
