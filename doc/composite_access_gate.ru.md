# CompositeAccessGate — примеры использования (RU)

`CompositeAccessGate` — универсальный виджет для объединения нескольких условий доступа. Поддерживает как синхронные, так и асинхронные проверки. Может использоваться в различных вариантах: `all`, `any`, `none`, `atLeast`.

## Пример: все условия должны быть `true`

```dart
CompositeAccessGate(
  conditions: [
    (ctx) => userHasRole(ctx, 'admin'),
    (ctx) => userHasPermission(ctx, 'edit'),
  ],
  child: Text('Доступ разрешён'),
  fallback: Text('Нет доступа'),
)
```

## Пример: хотя бы одно условие `true`

```dart
CompositeAccessGate.any(
  conditions: [
    (ctx) => userHasRole(ctx, 'manager'),
    (ctx) => userHasPermission(ctx, 'view'),
  ],
  child: Text('Ограниченный доступ'),
  fallback: Text('Недостаточно прав'),
)
```

## Пример: ни одно условие не должно быть `true`

```dart
CompositeAccessGate.none(
  conditions: [
    (ctx) => isInMaintenanceMode(ctx),
    (ctx) => userHasRole(ctx, 'banned'),
  ],
  child: Text('Сервис доступен'),
  fallback: Text('Сервис недоступен'),
)
```

## Пример: хотя бы `2` условия из списка `true`

```dart
CompositeAccessGate.atLeast(
  conditions: [
    (ctx) => check1(ctx),
    (ctx) => check2(ctx),
    (ctx) => check3(ctx),
  ],
  atLeastCount: 2,
  child: Text('Минимум два условия выполнены'),
  fallback: Text('Недостаточно условий'),
)
```

## Пример: с асинхронной проверкой

```dart
CompositeAccessGate(
  conditions: [
    (ctx) async => await fetchPermissionFromServer(ctx),
  ],
  loading: CircularProgressIndicator(),
  child: Text('Доступ подтверждён сервером'),
  fallback: Text('Ошибка доступа'),
)
```

## Пример: с builder API и колбэками

```dart
CompositeAccessGate.builder(
  conditions: [
    (ctx) => true,
    (ctx) => false,
  ],
  builder: (ctx, allowed) => Text(
    allowed ? 'Доступ есть' : 'Доступ запрещён',
  ),
  onAllow: () => print('✅ allow'),
  onDeny: () => print('❌ deny'),
  onError: (err) => print('⚠️ error: \$err'),
)
```