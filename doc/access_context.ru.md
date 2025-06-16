### AccessContext: Расширенная интеграция кастомного доступа

## Обзор

`AccessContext` — это абстрактный, типобезопасный интерфейс, предназначенный для обобщения логики доступа в вашем приложении. Он обеспечивает чистое разделение от `BuildContext` и позволяет работать с кастомными типами ролей, прав и фич-флагов.

⸻

## Определение интерфейса

```dart
abstract interface class AccessContext<R, P, F> {
  bool hasRole(R role);
  bool hasPermission(P permission);
  bool isFeatureEnabled(F flag);
}
```

- `R` – тип ролей (например, `enum`, `String`, `int` и др.)
- `P` – тип разрешений (permissions)
- `F` – тип фич-флагов

⸻

## Преимущества

- Типобезопасная проверка доступа
- Возможность использовать `enum`, `String` и т.д
- Полное отделение от UI-слоя (`BuildContext`)
- Удобство для юнит-тестирования
- Гибкость и масштабируемость

⸻

## Пример реализации

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

## Использование с AccessContextProvider

Для внедрения `AccessContext` в дерево виджетов:

```dart
AccessContextProvider(
  context: SessionContext(...),
  child: MyApp(),
);
```

Затем внутри любого виджета:

```dart
final context = AccessContextProvider.of<SessionContext>(context);
final allowed = context.hasPermission(Permission.edit);
```

Типизация защищает от ошибок на этапе компиляции — никакого риска опечаток в строках.

⸻

## Использование ContextAccessGate

Для декларативного контроля доступа:

```dart
ContextAccessGate<SessionContext>(
  context: AccessContextProvider.of(context),
  allow: (ctx) => ctx.hasRole(Role.admin),
  child: Text('Только для админов'),
  fallback: Text('Доступ запрещен'),
)
```

Или с асинхронной логикой и builder-ом:

```dart
ContextAccessGate<SessionContext>(
  context: AccessContextProvider.of(context),
  allow: (ctx) async => await Future.delayed(
    Duration(milliseconds: 50),
    () => ctx.hasPermission(Permission.export),
  ),
  loading: CircularProgressIndicator(),
  builder: (context, allowed) => Icon(
    allowed ? Icons.check_circle : Icons.block,
  ),
)
```

⸻

## Когда использовать AccessContext

Применяйте `AccessContext`, если:
- Вы хотите полностью отделить доступ от UI-контекста (`BuildContext`)
- Используете Riverpod, BLoC или другие DI-архитектуры
- Предпочитаете `enum` вместо строк
- Пишете тестируемые use-case'ы или сервисы
- Планируете использовать логику доступа вне UI
