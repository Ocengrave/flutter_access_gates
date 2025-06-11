# Обзор: Flutter Access Gates

## Основные компоненты

### `AccessGate<T>`
Базовый виджет, принимающий значение и функцию проверки (sync/async). Работает с любым типом `T`.

```dart
AccessGate<String>(
  input: 'admin',
  check: (ctx, role) => strategy.hasRole(ctx, role),
  child: Text('Доступ разрешен'),
  fallback: Text('Нет доступа'),
)
```

---

## Встроенные гейты

| Название             | Назначение                                      |
|----------------------|--------------------------------------------------|
| `RoleGate`           | Проверка по роли                                 |
| `PermissionGate`     | Проверка по пермишену                            |
| `FeatureGate`        | Проверка фичи (feature-flag)                     |
| `CompositeAccessGate`| Сложные логические условия                       |
| `DebugGate`          | UI только в debug-сборках                        |
| `GateUiBuilder`      | Синхронный builder с условием                    |

---

## Асинхронная поддержка

Все гейты работают и с `bool`, и с `Future<bool>` стратегиями.

```dart
AccessGate<String>(
  input: 'edit',
  check: (ctx, permission) async => await api.hasPermission(permission),
  loading: CircularProgressIndicator(),
  fallback: Text('Доступ запрещен'),
  child: Text('Разрешено'),
)
```

---

## AccessStrategy

Интерфейс, реализующий бизнес-логику:

```dart
abstract class AccessStrategy {
  bool hasRole(BuildContext context, String role);
  bool hasPermission(BuildContext context, String permission);
  bool isFeatureEnabled(BuildContext context, String flag);
}
```

Пример подключения:

```dart
AccessStrategyProvider(
  strategy: MyCustomStrategy(),
  child: MyApp(),
)
```

---

## Рекомендации

- Используйте `AccessGate<T>` напрямую для нестандартных сценариев
- Для отладки можно сделать `DevConsoleGate`/`AccessDebugPanel`

---

Документация актуальна для версии `0.2.0`