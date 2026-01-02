import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/core/app_constants.dart';
import 'package:mivro/features/home/providers/product_search_provider.dart';
import 'package:mivro/features/home/screens/product_detail_screen.dart';

class ProductSearchResults extends ConsumerWidget {
  const ProductSearchResults({super.key});

  String _getProductImageUrl(dynamic product) {
    if (product == null) return '';

    if (product['image_front_url'] != null &&
        product['image_front_url'].toString().isNotEmpty) {
      return product['image_front_url'].toString();
    }

    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(productSearchProvider);

    if (searchState.isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(color: mivroGreen),
        ),
      );
    }

    if (searchState.error != null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  searchState.error!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (searchState.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: searchState.products.length,
        itemBuilder: (context, index) {
          final product = searchState.products[index];
          return _buildProductCard(context, ref, product);
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> product,
  ) {
    final imageUrl = _getProductImageUrl(product);
    final productName = product['product_name'] ?? 'Unknown Product';
    final brands = product['brands'] ?? '';
    final code = product['code'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          await ref
              .read(productDetailProvider.notifier)
              .fetchProductDetail(productName, code);

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductDetailScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: mivroGray,
                            child: const Icon(
                              Icons.fastfood,
                              color: mivroGreen,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: mivroGray,
                        child: const Icon(
                          Icons.fastfood,
                          color: mivroGreen,
                          size: 40,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (brands.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        brands,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: mivroGreen, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
