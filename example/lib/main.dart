import 'package:flutter/material.dart';
import 'package:flutter_access_gates/flutter_access_gates.dart';
import 'package:flutter_access_gates_example/domain/feature_flags_enum.dart';
import 'launcher_app.dart';

void main() {
  final controller = FeatureFlagsController({
    AppFeature.darkMode.name: false,
    AppFeature.betaScreen.name: false,
    AppFeature.enableChat.name: true,
  });

  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final FeatureFlagsController controller;
  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FeatureFlags(
      controller: controller,
      child: Builder(
        builder: (context) {
          final flags = FeatureFlags.of(context);
          final isDark = flags.isEnabled(AppFeature.darkMode.name);

          return MaterialApp(
            title: 'Access Gates Examples',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const LauncherHomePage(),
          );
        },
      ),
    );
  }
}
