import 'package:flutter/material.dart';
import 'package:flutter_access_gates/adapters/access_context_provider.dart';
import 'package:flutter_access_gates_example/access_context_example.dart';
import 'package:flutter_access_gates_example/infrastructure/auth_session_provider.dart';
import 'package:provider/provider.dart';
import 'domain/dummy_session_context.dart';
import 'enum_feature_example.dart';
import 'provider_example.dart';

class LauncherHomePage extends StatelessWidget {
  const LauncherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔐 Access Gates — Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('EnumFeature Example'),
            subtitle: const Text(
                'Using enum for feature flags (swap theme here for pages)'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EnumFeatureExamplePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Provider Example'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => AuthSessionProvider(),
                    child: const ProviderExamplePage(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('AccessContext Example'),
            subtitle: const Text('Using AccessContext interface and gates'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AccessContextProvider(
                    context: DummySessionContext(),
                    child: const AccessContextExamplePage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
