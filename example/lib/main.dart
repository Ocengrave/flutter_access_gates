import 'package:flutter/material.dart';
import 'package:flutter_access_gates_example/infrastructure/auth_session_provider.dart';
import 'package:provider/provider.dart';
import 'fake_strategy_example.dart';
import 'provider_example.dart';

void main() {
  runApp(const LauncherApp());
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Access Gates Examples',
      home: LauncherHomePage(),
    );
  }
}

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
            title: const Text('FakeStrategy Example'),
            subtitle: const Text('Hard implementation'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FakeStrategyExampleApp(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Provider Example'),
            subtitle: const Text('Stateful session with ChangeNotifier'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => AuthSessionProvider(),
                    child: const ProviderExampleApp(),
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
