import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mivro/utils/api_constants.dart';

Future<Map<String, dynamic>> loadProfile(String email, String password) async {
  try {
    const String url = '${ApiConstants.baseUrl}/api/v1/user/load-profile';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      log('response: ${response.body}');
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      log('response: ${response.body}');
      return {};
    }
  } catch (e) {
    log(e.toString());
    return {};
  }
}
