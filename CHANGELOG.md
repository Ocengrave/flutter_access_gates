# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and follows [Semantic Versioning](https://semver.org/).

---

## [0.2.5] - 2025-06-16

### Added
- **CompositeAccessGate Enhancements**:
  - `CompositeVariant` support: `all`, `any`, `none`, `atLeast`
  - Named constructors: `.any`, `.none`, `.atLeast` (backward-compatible)
  - `onAllow`, `onDeny`, and `onError` callbacks
  - `builder` mode for fine-grained rendering
  - `debug` flag for logging condition evaluation
  - Full widget tests for sync/async + edge cases

- **AccessContext System (Experimental)**:
  - Introduced `AccessContext<R, P, F>` interface for DI-agnostic, type-safe access logic
  - Added `AccessContextProvider` for injecting access logic via `InheritedWidget`
  - New `ContextAccessGate` widget: supports `allow` function, fallback, async conditions, and builder-mode rendering
  - Complete examples and documentation in `/doc/access_context_*.md` (EN + RU)
  - Designed to support Riverpod, BLoC, and non-Flutter platforms

### Changed
- `CompositeAccessGate` internally refactored to improve maintainability
- Better code comments, inline DartDoc and debug readability
- Updated `README.md` and linked new docs for quick access

### Note
`AccessContext` is **non-breaking** and fully optional. Existing gates and BuildContext-based usage continue to work without changes. You can gradually adopt the new pattern if needed.

## [0.2.4] - 2025-06-11

### Changed
- Updated `README.md` with English version
- Updated `overview.md` with bilingual (RU/EN) documentation
- Improved recommendations and usage examples

### Fixed
- Minor formatting issues in documentation tables

## [0.2.3] - 2025-06-11

### Added
- Initial publish to pub.dev

### Changed
- Documentation moved to `doc/` directory

---

## [0.2.2] - 2025-06-10

### Added
- Tests for async `CompositeAccessGate`

### Changed
- `CompositeAccessGate` now supports both sync and async strategies

---

## [0.2.1] - 2025-06-09

### Documentation
- Detailed guide added in `docs/overview.md`
- Updated examples and structure

---

## [0.2.0] - 2025-06-09

### Added
- Async access strategy support for all gates
- `AccessGate<T>` now accepts `FutureOr<bool>` check

### Improved
- Extended unit tests for core logic

---

## [0.1.0] - 2025-06-09

### Added
- Base gates: `FeatureGate`, `RoleGate`, `PermissionGate`
- Composition: `CompositeAccessGate`, `GateUiBuilder`
- `DebugGate` for debug-only components
- `AccessStrategy`, `AccessStrategyProvider` for flexibility
- `MultiAccessStrategy` for combining strategies
- `FeatureFlagsController`, `FeatureFlags` for managing feature flags
- Lightweight `SimpleFeatureGate`
- Example usage in `example/`
- Full unit test coverage
