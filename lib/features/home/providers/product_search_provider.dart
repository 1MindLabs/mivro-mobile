import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/core/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSearchState {
  final List<dynamic> products;
  final bool isLoading;
  final String? error;

  ProductSearchState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  ProductSearchState copyWith({
    List<dynamic>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductSearchState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductSearchNotifier extends Notifier<ProductSearchState> {
  static const String _openFoodFactsUrl =
      'https://world.openfoodfacts.org/cgi/search.pl';
  static const String _userAgent = 'Mivro/1.0';

  @override
  ProductSearchState build() => ProductSearchState();

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      state = ProductSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final url = Uri.parse(_openFoodFactsUrl).replace(
        queryParameters: {
          'search_terms': query,
          'page': '1',
          'page_size': '20',
          'json': 'true',
          'fields':
              'code,product_name,brands,image_url,image_front_url,image_front_small_url,selected_images',
        },
      );

      final response = await http.get(url, headers: {'User-Agent': _userAgent});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'] ?? [];

        if (products.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            error: 'No products found. Try a different search term.',
          );
        } else {
          state = state.copyWith(products: products, isLoading: false);
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'An error occurred. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: Please check your connection.',
      );
    }
  }

  void clearResults() {
    state = ProductSearchState();
  }
}

class ProductDetailState {
  final Map<String, dynamic>? product;
  final bool isLoading;
  final String? error;

  ProductDetailState({this.product, this.isLoading = false, this.error});

  ProductDetailState copyWith({
    Map<String, dynamic>? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductDetailNotifier extends Notifier<ProductDetailState> {
  @override
  ProductDetailState build() => ProductDetailState();

  Future<void> fetchProductDetail(String productName, String code) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';

      final url = Uri.parse('${ApiConstants.baseUrl}/search/text').replace(
        queryParameters: {
          'search_query': productName.isNotEmpty ? productName : code,
          'page': '1',
          'page_size': '1',
        },
      );

      final header = <String, String>{
        'Mivro-Email': email,
        'Mivro-Password': password,
      };

      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'] ?? [];

        if (products.isNotEmpty) {
          state = state.copyWith(
            product: products[0] as Map<String, dynamic>,
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Product details not available',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load product details',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: Please check your connection.',
      );
    }
  }

  void clearDetail() {
    state = ProductDetailState();
  }
}

final productSearchProvider =
    NotifierProvider<ProductSearchNotifier, ProductSearchState>(
      ProductSearchNotifier.new,
    );

final productDetailProvider =
    NotifierProvider<ProductDetailNotifier, ProductDetailState>(
      ProductDetailNotifier.new,
    );
