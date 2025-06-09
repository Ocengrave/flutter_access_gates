import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/gates/debug_gate.dart';

void main() {
  group('DebugGate', () {
    testWidgets('shows child in debug mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DebugGate(child: Text('Debug Visible'))),
      );

      expect(
        find.text('Debug Visible'),
        kDebugMode ? findsOneWidget : findsNothing,
      );
    });

    testWidgets('shows fallback in release mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DebugGate(
            fallback: Text('Not in Debug'),
            child: Text('Debug Visible'),
          ),
        ),
      );

      final expected = kDebugMode ? 'Debug Visible' : 'Not in Debug';
      expect(find.text(expected), findsOneWidget);
    });
  });
}
