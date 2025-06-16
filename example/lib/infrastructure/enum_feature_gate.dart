import 'package:flutter/material.dart';
import 'package:flutter_access_gates/gates/feature_gate.dart';

class EnumFeatureGate<T extends Enum> extends StatelessWidget {
  final T flag;
  final Widget child;
  final Widget fallback;

  const EnumFeatureGate({
    super.key,
    required this.flag,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return FeatureGate(
      flag: flag.name,
      fallback: fallback,
      child: child,
    );
  }
}
