import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';

void main() {
  testWidgets('FeatureGate shows child if flag enabled', (tester) async {
    final controller = FeatureFlagsController({'cool_feature': true});

    await tester.pumpWidget(
      FeatureFlags(
        controller: controller,
        child: MaterialApp(
          home: Scaffold(
            body: FeatureGate(
              flag: 'cool_feature',
              child: Text('Feature Enabled'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Feature Enabled'), findsOneWidget);
  });

  testWidgets('FeatureGate hides child if flag disabled', (tester) async {
    final controller = FeatureFlagsController({'cool_feature': false});

    await tester.pumpWidget(
      FeatureFlags(
        controller: controller,
        child: MaterialApp(
          home: Scaffold(
            body: FeatureGate(
              flag: 'cool_feature',
              child: Text('Feature Disabled'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Feature Disabled'), findsNothing);
  });
}
