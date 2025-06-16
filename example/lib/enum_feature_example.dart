import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'domain/feature_flags_enum.dart';
import 'infrastructure/enum_feature_gate.dart';

final class EnumFeatureExamplePage extends StatelessWidget {
  const EnumFeatureExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FeatureFlagsController flags = FeatureFlags.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('EnumFeature Example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final feature in AppFeature.values)
            SwitchListTile(
              title: Text(feature.label),
              value: flags.isEnabled(feature.name),
              onChanged: (value) => flags.updateFlag(feature.name, value),
            ),
          const Divider(),
          const EnumFeatureGate<AppFeature>(
            flag: AppFeature.betaScreen,
            child: ListTile(title: Text('🎉 Beta screen enabled')),
          ),
          const EnumFeatureGate<AppFeature>(
            flag: AppFeature.enableChat,
            child: ListTile(title: Text('💬 Chat is available')),
          ),
        ],
      ),
    );
  }
}
