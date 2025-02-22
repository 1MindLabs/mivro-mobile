import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String email;
  final String password;

  AuthState({required this.email, required this.password});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(email: "", password: ""));

  void updateCredentials(String email, String password) {
    state = AuthState(email: email, password: password);
  }

  void clearCredentials() {
    state = AuthState(email: "", password: "");
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
