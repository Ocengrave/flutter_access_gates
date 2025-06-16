import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_access_gates/adapters/access_context.dart';
import 'package:flutter_access_gates/adapters/access_context_provider.dart';

final class DummyAccessContext
    implements AccessContext<String, String, String> {
  @override
  bool hasPermission(String permission) => permission == 'edit';

  @override
  bool hasRole(String role) => role == 'admin';

  @override
  bool isFeatureEnabled(String flag) => flag == 'dark';
}

void main() {
  testWidgets('AccessContextProvider provides context correctly', (
    tester,
  ) async {
    final contextInstance = DummyAccessContext();

    late AccessContext retrieved;

    await tester.pumpWidget(
      MaterialApp(
        home: AccessContextProvider(
          context: contextInstance,
          child: Builder(
            builder: (ctx) {
              retrieved = AccessContextProvider.of(ctx);
              return const Text('OK');
            },
          ),
        ),
      ),
    );

    expect(find.text('OK'), findsOneWidget);
    expect(retrieved, isA<DummyAccessContext>());
    expect(retrieved.hasPermission('edit'), isTrue);
    expect(retrieved.hasRole('admin'), isTrue);
  });
  test('updateShouldNotify returns true when context changes', () {
    final c1 = DummyAccessContext();
    final c2 = DummyAccessContext();

    final provider1 = AccessContextProvider(context: c1, child: Container());
    final provider2 = AccessContextProvider(context: c2, child: Container());

    expect(provider1.updateShouldNotify(provider2), isTrue);
    expect(provider1.updateShouldNotify(provider1), isFalse);
  });
}
