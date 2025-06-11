# Обзор: Flutter Access Gates

**Flutter Access Gates** — это декларативный способ управления доступом к UI-компонентам на основе фич-флагов, прав, ролей или любых кастомных условий.

> 💡 Вместо `if (user.hasPermission(...))` — используйте понятные `Gate`-виджеты прямо в разметке.

---

## Что решает

- Хочешь **спрятать кнопку** от неподходящих ролей?
- Показать фичу только в `debug`?
- Показать блок только при включённом фич-флаге?
- Или использовать любую свою логику доступа?

**Access Gates** дают готовые декларативные виджеты для этого.

---

## Основной компонент: `AccessGate<T>`

```dart
AccessGate<String>(
  input: 'admin',
  check: (ctx, role) => strategy.hasRole(ctx, role),
  child: Text('Добро пожаловать, админ!'),
  fallback: Text('Нет доступа'),
)
```

- `input`: что проверяем (роль, permission, флаг и т.д.)
- `check`: функция проверки (можно async)
- `child`: если доступ разрешён
- `fallback`: если доступ запрещён
- `loading`: пока ждём результат

---

## Встроенные гейты

| Виджет                 | Для чего нужен                          |
|------------------------|-----------------------------------------|
| `RoleGate`             | Проверка роли                           |
| `PermissionGate`       | Проверка прав доступа                   |
| `FeatureGate`          | Проверка включённости флага             |
| `CompositeAccessGate`  | Несколько условий (AND)                 |
| `DebugGate`            | Только в debug-сборках                  |
| `GateUiBuilder`        | Кастомная синхронная проверка           |
| `SimpleFeatureGate`    | Без стратегии, просто Map с флагами     |

---

## Асинхронные проверки — без боли

```dart
AccessGate<String>(
  input: 'edit',
  check: (ctx, perm) async => await api.hasPermission(perm),
  loading: CircularProgressIndicator(),
  fallback: Text('Нет доступа'),
  child: Text('Редактирование разрешено'),
)
```
---

## Стратегия доступа (`AccessStrategy`)

```dart
abstract class AccessStrategy {
  bool hasRole(BuildContext context, String role);
  bool hasPermission(BuildContext context, String permission);
  bool isFeatureEnabled(BuildContext context, String flag);
}
```

Ты можешь использовать свою реализацию:

```dart
AccessStrategyProvider(
  strategy: MyStrategy(),
  child: MyApp(),
)
```

Или вообще не использовать стратегию — `SimpleFeatureGate` работает на `Map<String, bool>`.

---

## Когда использовать

| Сценарий                          | Решение                    |
|----------------------------------|----------------------------|
| Показывать кнопку "Удалить"      | `PermissionGate(permission: 'delete')` |
| Показать dev-фичу                | `FeatureGate(flag: 'dev_console')` |
| Скрыть блок в релизе             | `DebugGate(child: ...)` |
| Своя логика по jwt/контексту     | `AccessGate<T>` с кастомной `check` |
| Комбинированные условия          | `CompositeAccessGate([...])` |

---

## Рекомендации

- Для асинхронных условий — обязательно задавай `loading`

---

## Эта документация соответствует версии `0.2.3`

---