# flutter_access_gates

**Declarative access control for Flutter UI.**

> 🔐 Feature flags, permission-based widgets, role gates, and flexible access strategies — all in one.

---

## ✨ Возможности

| Гейт                 | Назначение                       |
|----------------------|----------------------------------|
| `FeatureGate`        | По фиче-флагам                   |
| `PermissionGate`     | По правам доступа                |
| `RoleGate`           | По ролям пользователя            |
| `GateUiBuilder`      | По кастомным условиям            |
| `CompositeAccessGate`| Все условия `AND`                |
| `DebugGate`          | Только в debug-сборке            |
| `SimpleFeatureGate`  | Без стратегии, только Map        |

## Пример использования

```dart
import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';

void main() {
  runApp(const ExampleApp());
}

final class FakeAccessStrategy implements AccessStrategy {
  final Set<String> allowedPermissions;
  final Set<String> allowedRoles;
  final Set<String> enabledFeatures;

  const FakeAccessStrategy({
    this.allowedPermissions = const {},
    this.allowedRoles = const {},
    this.enabledFeatures = const {},
  });

  @override
  bool hasPermission(BuildContext context, String permission) {
    return allowedPermissions.contains(permission);
  }

  @override
  bool hasRole(BuildContext context, String role) {
    return allowedRoles.contains(role);
  }

  @override
  bool isFeatureEnabled(BuildContext context, String flag) {
    return enabledFeatures.contains(flag);
  }
}

final class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureFlags(
      controller: FeatureFlagsController({'dev_mode': true}),
      child: AccessStrategyProvider(
        strategy: const FakeAccessStrategy(
          allowedRoles: {'admin'},
          allowedPermissions: {'edit'},
          enabledFeatures: {'dev_mode'},
        ),
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Access Gates Example')),
            body: const ExamplePage(),
          ),
        ),
      ),
    );
  }
}

final class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FeatureGate(
          flag: 'dev_mode',
          child: Text('FeatureGate: dev_mode active'),
        ),
        const PermissionGate(
          permission: 'edit',
          child: Text('PermissionGate: edit granted'),
        ),
        const RoleGate(
          role: 'admin',
          child: Text('RoleGate: admin'),
        ),
        GateUiBuilder(
          condition: (ctx) => true,
          builder: (_) => const Text('GateUiBuilder: always shown'),
        ),
        CompositeAccessGate(
          conditions: [
            (ctx) => true,
            (ctx) => true,
          ],
          child: const Text('CompositeGate: all conditions passed'),
        ),
        const DebugGate(
          fallback: Text('DebugGate: fallback (not debug)'),
          child: Text('DebugGate: only in debug'),
        ),
      ],
    );
  }
}
```

## Концепция

Вместо ручной проверки условий доступа:
```dart
if (user.hasPermission('edit')) {
  return ElevatedButton(...);
}
```

Вы просто используете декларативный виджет:

```dart
PermissionGate(
  permission: 'edit',
  child: ElevatedButton(...),
)
```

## Установка

Добавьте пакет в pubspec.yaml, используя ссылку на GitHub:

```yaml
dependencies:
  flutter_access_gates: ^0.2.2
```

Затем выполните:
```bash
flutter pub get
```