import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? name;
  final String? rollNo;
  final String? course;
  final String? dept;
  final String? section;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.username,
    this.name,
    this.rollNo,
    this.course,
    this.dept,
    this.section,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? username,
    String? name,
    String? rollNo,
    String? course,
    String? dept,
    String? section,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      course: course ?? this.course,
      dept: dept ?? this.dept,
      section: section ?? this.section,
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
      state = AuthState(
        status: AuthStatus.authenticated,
        username: saved,
        name: prefs.getString('name'),
        rollNo: prefs.getString('rollNo'),
        course: prefs.getString('course'),
        dept: prefs.getString('dept'),
        section: prefs.getString('section'),
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String username, String password, String captcha) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    // TODO: Replace with real API call — populate fields from API response
    await Future.delayed(const Duration(seconds: 2));

    if (username.isNotEmpty && password.isNotEmpty && captcha.isNotEmpty) {
      // Mock student data — swap with real API response fields
      const mockName = 'YUGA T';
      const mockRollNo = '23IT1251';
      const mockCourse = 'BTECH';
      const mockDept = 'IT';
      const mockSection = 'D';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('name', mockName);
      await prefs.setString('rollNo', mockRollNo);
      await prefs.setString('course', mockCourse);
      await prefs.setString('dept', mockDept);
      await prefs.setString('section', mockSection);

      state = AuthState(
        status: AuthStatus.authenticated,
        username: username,
        name: mockName,
        rollNo: mockRollNo,
        course: mockCourse,
        dept: mockDept,
        section: mockSection,
      );
      return true;
    }

    state = const AuthState(
      status: AuthStatus.unauthenticated,
      error: 'Invalid credentials. Please try again.',
    );
    return false;
  }

  Future<void> logout() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.removeWhere((key, _) => true); // clear all saved session data
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);
