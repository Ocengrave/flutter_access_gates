# Changelog

Все значимые изменения в этом проекте будут документироваться в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/)
и проекте [Semantic Versioning](https://semver.org/lang/ru/).

---

## [0.1.0] - 2025-06-09

### Добавлено

- 🎯 Базовый функционал:
  - `FeatureGate`, `RoleGate`, `PermissionGate` — для контроля доступа к UI
  - `CompositeGate` и `GateUiBuilder` — кастомные условия и композиция
  - `DebugGate` — для отображения компонентов только в debug-сборках
- ⚙️ Система `AccessStrategy` и `AccessStrategyProvider` для полной масштабируемости
- 🔌 `MultiAccessStrategy` — объединение нескольких стратегий
- 🌐 `FeatureFlagsController` + `FeatureFlags` — управление feature-флагами через `InheritedNotifier`
- 🧪 Покрытие unit-тестами всех компонентов (гейты, стратегии, провайдеры)
- 🔨 Упрощённый `SimpleFeatureGate` для YAML, RemoteConfig и локальных конфигов
- 📦 Пример использования в `example/` с фейковой стратегией

---