import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

/// Watches auth state and routes to the correct screen instantly.
/// No splash — shows login or home immediately based on saved session.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    switch (auth.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        // Briefly show a plain dark screen while shared_prefs loads
        return const Scaffold(
          backgroundColor: Color(0xFF08111E),
        );

      case AuthStatus.authenticated:
        return const HomeScreen();

      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}