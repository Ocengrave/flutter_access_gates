# flutter_access_gates

**Declarative access control for Flutter UI.**

> 🔐 Feature flags, permission-based widgets, role gates, and flexible access strategies — all in one.

---

<<<<<<< Updated upstream
## ✨ Особенности

- ✅ `FeatureGate` — доступ по фиче-флагам
- ✅ `PermissionGate` — доступ по правам
- ✅ `RoleGate` — доступ по ролям
- ✅ `GateUiBuilder` — настраиваемые условия
- ✅ `CompositeAccessGate` — объединение условий
- ✅ `DebugGate` — доступ только в debug-сборке
- ✅ `SimpleFeatureGate` — минималистичная замена без стратегии
- ✅ Полная поддержка `AccessStrategy` (можно подключать свои стратегии)
- ✅ Горячая перезагрузка

---

## 🚀 Пример использования
=======
## ✨ Opportunities

| Gates                | Purpose                       |
|----------------------|----------------------------------|
| `FeatureGate`        | By future flags                  |
| `PermissionGate`     | By permission rules              |
| `RoleGate`           | By user roles                    |
| `GateUiBuilder`      | By custom condtioons             |
| `CompositeAccessGate`| All conditions  `AND`            |
| `DebugGate`          | Only in debug-mode               |
| `SimpleFeatureGate`  | Only Map use                     |

## Use Example
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
## 🧠 Концепция
=======
## Conceptions
>>>>>>> Stashed changes

Instead of manual access conditions check: 
```dart
if (user.hasPermission('edit')) {
  return ElevatedButton(...);
}
```

Simply using declarative widget:

```dart
PermissionGate(
  permission: 'edit',
  child: ElevatedButton(...),
)
```

<<<<<<< Updated upstream
## 🚀 Установка
=======
## Install
>>>>>>> Stashed changes

Add pakage in pubspec.yaml:

```yaml
dependencies:
  flutter_access_gates: ^0.2.2
```

Then execute:
```bash
flutter pub get
```

### ⚠️ Пакет пока не опубликован на pub.dev. Установка доступна только через GitHub.