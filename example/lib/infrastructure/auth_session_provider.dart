import 'package:flutter/material.dart';
import 'package:flutter_access_gates_example/domain/auth_session.dart';

final class AuthSessionProvider extends ChangeNotifier {
  AuthSession? _session;
  bool _loading = true;
  bool _error = false;

  AuthSession? get session => _session;
  bool get isLoading => _loading;
  bool get hasError => _error;

  AuthSessionProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _session = const AuthSession(
        userId: 'user_123',
        roles: {'admin'},
        permissions: {'edit', 'export'},
        features: {'dev_mode'},
      );
    } catch (_) {
      _error = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
