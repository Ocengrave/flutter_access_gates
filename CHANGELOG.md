# Changelog

Все значимые изменения в этом проекте будут документироваться в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/)
и проекте [Semantic Versioning](https://semver.org/lang/ru/).

---
## [0.2.3] - 2025-06-1

### Добавлено
- Публикация на pub.dev

### Изменено
- docs перенесены в папку doc

---
## [0.2.2] - 2025-06-10

### Добавлено
- Добавлены тесты для асинхронного CompositeAccessGate

### Изменено
- CompositeAccessGate теперь может быть как sync так и async


## [0.2.1] - 2025-06-09

### Документация
- Добавлена подробная документация (`docs/overview.md`)
- Обновлены примеры, рекомендации, структура каталогов

## [0.2.0] - 2025-06-09

### Добавлено
- Поддержка асинхронных проверок доступа:
    - AccessGate<T> теперь принимает FutureOr<bool> Function(...) — можно использовать async-функции
	- Гейты (FeatureGate, PermissionGate, RoleGate, CompositeAccessGate) теперь работают как с синхронными, так и с асинхронными стратегиями

### Улучшено
- Обновлены unit-тесты


## [0.1.0] - 2025-06-09

### Добавлено

- Базовый функционал:
  - `FeatureGate`, `RoleGate`, `PermissionGate` — для контроля доступа к UI
  - `CompositeAccessGate` и `GateUiBuilder` — кастомные условия и композиция
  - `DebugGate` — для отображения компонентов только в debug-сборках
- `AccessStrategy` и `AccessStrategyProvider` для полной масштабируемости
- `MultiAccessStrategy` — объединение нескольких стратегий
- `FeatureFlagsController` + `FeatureFlags` — управление feature-флагами через `InheritedNotifier`
- Покрытие unit-тестами всех компонентов (гейты, стратегии, провайдеры)
- Упрощённый `SimpleFeatureGate` для быстрого прототипирования
- Пример использования в `example/` с фейковой стратегией

---