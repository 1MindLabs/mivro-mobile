import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/core/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  Future<Map<String, dynamic>> getProductDetails(String barcode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final url =
          '${ApiConstants.baseUrl}/search/barcode?product_barcode=$barcode';

      final header = <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
      };

      final response = await http.get(Uri.parse(url), headers: header);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        state = data;
        return data;
      } else if (response.statusCode == 404) {
        throw Exception("Product not found.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error.");
      } else {
        throw Exception("Unexpected error occurred.");
      }
    } catch (e) {
      throw Exception("Network error: Please check your connection.");
    }
  }

  void clearProductDetails() {
    state = {};
  }
}

final productDetailsProvider =
    NotifierProvider<ProductDetailsNotifier, Map<String, dynamic>>(
      ProductDetailsNotifier.new,
    );
