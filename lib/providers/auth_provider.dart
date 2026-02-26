import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.username,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('username');
    if (saved != null) {
      state = AuthState(status: AuthStatus.authenticated, username: saved);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String username, String password, String captcha) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    await Future.delayed(const Duration(seconds: 2));

    if (username.isNotEmpty && password.isNotEmpty && captcha.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      state = AuthState(status: AuthStatus.authenticated, username: username);
      return true;
    }

    state = AuthState(
      status: AuthStatus.unauthenticated,
      error: 'Invalid credentials. Please try again.',
    );
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);