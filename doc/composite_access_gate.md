# CompositeAccessGate Examples

This document demonstrates various use cases of `CompositeAccessGate`, including synchronous and asynchronous access checks, different evaluation variants, and usage of the `builder` API.

---

## Basic (All Conditions Must Be True)

```dart
CompositeAccessGate(
  conditions: [
    (ctx) => true,
    (ctx) => true,
  ],
  child: Text('Access granted'),
  fallback: Text('Access denied'),
)
```

---

## Variant: Any (At Least One True)

```dart
CompositeAccessGate.any(
  conditions: [
    (ctx) => false,
    (ctx) => true,
  ],
  child: Text('Access granted'),
  fallback: Text('Access denied'),
)
```

---

## Variant: None (All Must Be False)

```dart
CompositeAccessGate.none(
  conditions: [
    (ctx) => false,
    (ctx) => false,
  ],
  child: Text('All conditions were false'),
  fallback: Text('Some condition was true'),
)
```

---

## Variant: At Least (Min N True)

```dart
CompositeAccessGate.atLeast(
  atLeastCount: 2,
  conditions: [
    (ctx) => true,
    (ctx) => false,
    (ctx) => true,
  ],
  child: Text('At least 2 were true'),
  fallback: Text('Not enough true conditions'),
)
```

---

## Custom Builder

```dart
CompositeAccessGate.builder(
  conditions: [
    (ctx) => true,
    (ctx) => false,
  ],
  builder: (ctx, allowed) {
    return allowed
      ? Icon(Icons.lock_open)
      : Icon(Icons.lock);
  },
)
```

---

## Async Conditions with Loading

```dart
CompositeAccessGate(
  conditions: [
    (ctx) async {
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    },
    (ctx) => true,
  ],
  loading: CircularProgressIndicator(),
  child: Text('All passed'),
  fallback: Text('Blocked'),
)
```

---

## Debug Mode with Logging

```dart
CompositeAccessGate(
  debug: true,
  conditions: [
    (ctx) => true,
    (ctx) => false,
  ],
  child: Text('Access granted'),
  fallback: Text('Access denied'),
)
```

Console output:
```
[CompositeAccessGate] Variant: CompositeVariant.all
[Condition 0] Result: true
[Condition 1] Result: false
[CompositeAccessGate] Final decision: false
```

---

## Callbacks

```dart
CompositeAccessGate(
  conditions: [(_) => true],
  onAllow: () => print('✅ allowed'),
  onDeny: () => print('❌ denied'),
  onError: (e) => print('💥 error: $e'),
  child: Text('Allowed'),
  fallback: Text('Denied'),
)
```

---

For more advanced integrations (like Riverpod, Injected, or other DI strategies), you can use the `CompositeAccessGate.builder` and pass conditions using context extensions or injected references.