import 'package:flutter/material.dart';
import 'package:flutter_access_gates/adapters/access_context_provider.dart';
import 'package:flutter_access_gates/gates/context_access_gate.dart';

final class AccessContextExamplePage extends StatelessWidget {
  const AccessContextExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('AccessContext Example')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('ContextAccessGate with sync check'),
            ContextAccessGate(
              context: AccessContextProvider.of(context),
              allow: (ctx) => ctx.hasRole('admin'),
              fallback: const Text('Not an admin'),
              child: const Text('Admin role allowed'),
            ),
            const SizedBox(height: 24),
            const Text('ContextAccessGate with async + builder'),
            SizedBox(
              width: 100,
              height: 50,
              child: ContextAccessGate(
                context: AccessContextProvider.of(context),
                allow: (ctx) async {
                  await Future.delayed(const Duration(milliseconds: 1000));
                  return ctx.isFeatureEnabled('dark_mode');
                },
                loading: const CircularProgressIndicator(),
                builder: (_, allowed) => Icon(
                  allowed ? Icons.subdirectory_arrow_left : Icons.block,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
