import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String email;
  final String password;

  AuthState({required this.email, required this.password});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState(email: "", password: "");

  void updateCredentials(String email, String password) {
    state = AuthState(email: email, password: password);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
