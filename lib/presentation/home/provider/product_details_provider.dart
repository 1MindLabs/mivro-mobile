import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsNotifier extends StateNotifier<Map<String, dynamic>> {
  ProductDetailsNotifier() : super({});

  Future<Map<String, dynamic>> getProductDetails(String barcode) async {
    try {
      const String url = '${ApiConstants.baseUrl}/api/v1/search/barcode';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final header = <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
        'Content-Type': 'application/json',
      };

      final body = <String, String>{
        'product_barcode': barcode,
      };

      final response = await http.post(Uri.parse(url),
          headers: header, body: json.encode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        
        log('Success: $data');
        state = data;
        return data;
      }
      
      // Handle 404 Not Found
      else if (response.statusCode == 404) {
        log('Error 404: Product not found.');
        throw Exception("Product not found.");
      }
      
      // Handle 500 Internal Server Error
      else if (response.statusCode == 500) {
        log('Error 500: Server error.');
        throw Exception(response.body);
      }
      
      // Handle any other error
      else {
        log('Error: ${response.body} with status code: ${response.statusCode}');
        throw Exception("Unexpected error occurred.");
      }
    } catch (e) {
      log('Exception: $e');
      throw Exception("Network error: Please check your connection.");
    }
  }

  void clearProductDetails() {
    state = {};
  }
}

final productDetailsProvider =
    StateNotifierProvider<ProductDetailsNotifier, Map<String, dynamic>>(
        (ref) => ProductDetailsNotifier());
