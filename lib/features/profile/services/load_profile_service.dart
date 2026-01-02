import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mivro/core/api_constants.dart';

Future<Map<String, dynamic>> loadProfile(String email, String password) async {
  try {
    const String url = '${ApiConstants.baseUrl}/user/load-profile';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      return {};
    }
  } catch (e) {
    return {};
  }
}
