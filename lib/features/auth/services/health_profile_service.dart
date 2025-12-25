import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mivro/features/auth/models/personal_details.dart';
import 'package:mivro/core/api_constants.dart';

Future<Map<String, dynamic>> healthProfile(
  PersonalDetails personalDetails,
  String email,
  String password,
) async {
  try {
    const String url = '${ApiConstants.baseUrl}/user/health-profile';

    var body = {
      'age': personalDetails.age,
      'gender': personalDetails.gender,
      'height': personalDetails.height,
      'weight': personalDetails.weight,
      'dietary_preferences': personalDetails.dietaryPreference,
      'medical_conditions': personalDetails.medicalCondition,
      'allergies': personalDetails.allergy,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
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
