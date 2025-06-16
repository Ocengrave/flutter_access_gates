### AccessContext: Advanced Custom Access Integration

## Overview

AccessContext is an abstract, type-safe interface designed to generalize access logic in your application. It offers a clean separation from BuildContext and allows working with custom role, permission, and feature types.

⸻

## Interface Definition

```dart
abstract interface class AccessContext<R, P, F> {
  bool hasRole(R role);
  bool hasPermission(P permission);
  bool isFeatureEnabled(F flag);
}
```

- R – Type of roles (e.g., enum, String, int, etc.)
- P – Type of permissions
- F – Type of feature flags

⸻

Benefits
- Type-safe access control
- Freedom to define enums, or strings and e.t.c
- Clean decoupling from UI-layer and BuildContext
- Test-friendly access contracts
- Scalable and extendable

⸻

## Example Implementation


```dart
enum Role { admin, user }

enum Permission { edit, export }

enum FeatureFlag { darkMode, betaScreen }

final class SessionContext
    implements AccessContext<Role, Permission, FeatureFlag> {
  final Set<Role> roles;
  final Set<Permission> permissions;
  final Set<FeatureFlag> features;

  SessionContext({
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
```

⸻

## Usage with AccessContextProvider

To expose an AccessContext instance throughout your widget tree, use the AccessContextProvider:

```dart
AccessContextProvider(
  context: SessionContext(...),
  child: MyApp(),
);
```

Then retrieve it inside any widget using:

```dart
final context = AccessContextProvider.of<SessionContext>(context);
final allowed = context.hasPermission(Permission.edit);
```

Generic typing ensures compile-time safety — no runtime string errors.

## Using ContextAccessGate
To declaratively restrict access in your UI with the context instance:
```dart
ContextAccessGate<SessionContext>(
  context: AccessContextProvider.of(context),
  allow: (ctx) => ctx.hasRole(Role.admin),
  child: Text('Admin only'),
  fallback: Text('Access denied'),
)
```

Or, for more control:
```dart
ContextAccessGate<SessionContext>(
  context: AccessContextProvider.of(context),
  allow: (ctx) async => await Future.delayed(Duration(milliseconds: 50), () => ctx.hasPermission(Permission.export)),
  loading: CircularProgressIndicator(),
  builder: (context, allowed) => Icon(
    allowed ? Icons.check_circle : Icons.block,
  ),
)
```

### When to Use AccessContext

Use AccessContext when:
- You want to decouple access logic from BuildContext
- You’re using Riverpod, BLoC, or other DI-centric architectures
- You prefer type-safe enums or sealed types instead of strings
- You’re testing access policies in isolation
- You want to compose logic outside of UI (e.g., in services, commands, use cases)