import 'package:flutter_access_gates/adapters/access_context.dart';

final class DummySessionContext
    implements AccessContext<String, String, String> {
  @override
  bool hasRole(String role) => role == 'admin';

  @override
  bool hasPermission(String permission) => permission == 'edit';

  @override
  bool isFeatureEnabled(String flag) => flag == 'dark_mode';
}
