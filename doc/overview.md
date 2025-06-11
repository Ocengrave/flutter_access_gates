# Overview: Flutter Access Gates
**Flutter Access Gates** is a declarative way to manage access to UI components based on feature flags, permissions, roles, or any custom condition.

> 💡 Instead of writing `if (user.hasPermission(...))`, just use intuitive `Gate` widgets right in your widget tree.

---

## What It Solves

- Want to **hide a button** from unauthorized roles?
- Show a feature only in `debug` mode?
- Render a block only when a feature flag is enabled?
- Or apply your own custom logic?

**Access Gates** provide ready-to-use declarative widgets for all of this.

---

## Core Widget: `AccessGate<T>`

```dart
AccessGate<String>(
  input: 'admin',
  check: (ctx, role) => strategy.hasRole(ctx, role),
  child: Text('Welcome, admin!'),
  fallback: Text('Access denied'),
)
```

- `input`: the value to check (role, permission, flag, etc.)
- `check`: the function to validate it (sync or async)
- `child`: shown when access is granted
- `fallback`: shown when access is denied
- `loading`: shown while waiting for the result
---

## Built-in Gates

| Widget                  | Purpose                                  |
|-------------------------|------------------------------------------|
| `RoleGate`              | Role-based access                        |
| `PermissionGate`        | Permission-based access                  |
| `FeatureGate`           | Feature flag checking                    |
| `CompositeAccessGate`   | Combine multiple conditions (`AND`)      |
| `DebugGate`             | Render only in debug builds              |
| `GateUiBuilder`         | Custom sync condition                    |
| `SimpleFeatureGate`     | Flag-only version without a strategy     |

---

## Async Checks — Done Right

```dart
AccessGate<String>(
  input: 'edit',
  check: (ctx, permission) async => await api.hasPermission(permission),
  loading: CircularProgressIndicator(),
  fallback: Text('Access denied'),
  child: Text('Edit access granted'),
)
```

---

## AccessStrategy
```dart
abstract class AccessStrategy {
  bool hasRole(BuildContext context, String role);
  bool hasPermission(BuildContext context, String permission);
  bool isFeatureEnabled(BuildContext context, String flag);
}
```

You can implement and plug in your own strategy:

```dart
AccessStrategyProvider(
  strategy: MyCustomStrategy(),
  child: MyApp(),
)
```

Or use a simple `Map<String, bool>` with `SimpleFeatureGate` if no strategy is needed.

---

## When to Use

| Scenario                        | Use                                 |
|---------------------------------|--------------------------------------|
| Show "Delete" button            | `PermissionGate(permission: 'delete')` |
| Show dev feature                | `FeatureGate(flag: 'dev_console')`  |
| Hide UI in release mode         | `DebugGate(child: ...)`             |
| Custom logic via JWT/context    | `AccessGate<T>` with custom `check` |
| Combine multiple conditions     | `CompositeAccessGate([...])`        |

---

## Recommendations

- For async checks, always specify a `loading` widget

---
## This documentation corresponds to version `0.2.3`