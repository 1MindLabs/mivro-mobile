import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsNotifier extends StateNotifier<Map<String, dynamic>> {
  ProductDetailsNotifier() : super({});

  Future<Map<String, dynamic>> getProductDetails(String barcode) async {
    try {
      const String url = 'http://192.168.160.94:5000/api/v1/search/barcode';

      const header = <String, String>{
        'Mivro-Email': 'admin@mivro.org',
        'Mivro-Password': 'admin@123',
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
        log(data.toString());
        state = data;

        return data;
      } else {
        log('Error: ${response.body} with status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      log(e.toString());
      return {};
    }
  }

  void clearProductDetails() {
    state = {};
  }
}

final productDetailsProvider =
    StateNotifierProvider<ProductDetailsNotifier, Map<String, dynamic>>(
        (ref) => ProductDetailsNotifier());
