import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, AsyncValue<bool>>((ref) {
  return ResetPasswordNotifier();
});

class ResetPasswordNotifier extends StateNotifier<AsyncValue<bool>> {
  ResetPasswordNotifier() : super(const AsyncValue.data(false));

  Future<void> resetPassword({required String email}) async {
    const String url = 'http://10.1.6.186:5000/api/v1/auth/reset-password';

    try {
      state = const AsyncValue.loading();
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        state = const AsyncValue.data(true);
      } else {
        state = const AsyncValue.data(false);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
