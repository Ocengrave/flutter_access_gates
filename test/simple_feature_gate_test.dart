import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('SimpleFeatureGate with YAML', () {
    testWidgets('loads flags from YAML and shows correct widget', (
      tester,
    ) async {
      const yamlString = '''
        dev_mode: true
        experimental_ui: false
      ''';

      final YamlMap yamlMap = loadYaml(yamlString) as YamlMap;

      final Map<String, bool> flags = <String, bool>{
        for (final entry in yamlMap.entries)
          entry.key.toString(): entry.value == true,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              SimpleFeatureGate(
                flags: flags,
                flag: 'dev_mode',
                fallback: const Text('Dev mode disabled'),
                child: const Text('Dev mode enabled'),
              ),
              SimpleFeatureGate(
                flags: flags,
                flag: 'experimental_ui',
                fallback: const Text('Old UI'),
                child: const Text('Experimental UI'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Dev mode enabled'), findsOneWidget);
      expect(find.text('Old UI'), findsOneWidget);
      expect(find.text('Dev mode disabled'), findsNothing);
      expect(find.text('Experimental UI'), findsNothing);
    });
  });
}
