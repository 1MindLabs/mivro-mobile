import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mivro/presentation/auth/model/personal_details.dart';
import 'package:mivro/utils/api_constants.dart';

Future<Map<String, dynamic>> healthProfile(
    PersonalDetails personalDetails, String email, String password) async {
  try {
    const String url = '${ApiConstants.baseUrl}/api/v1/user/health-profile';

    var body = {
      'age': personalDetails.age,
      'gender': personalDetails.gender,
      'height': personalDetails.height,
      'weight': personalDetails.weight,
      'dietary_preferences': personalDetails.dietaryPreference,
      'medical_conditions': personalDetails.medicalCondition,
      'allergys': personalDetails.allergy,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
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
