import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mivro/core/api_constants.dart';

Future<bool> createAccount(String email, String password) async {
  try {
    const String url = '${ApiConstants.baseUrl}/auth/signup';

    var body = {'email': email, 'password': password};

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
