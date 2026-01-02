import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/core/app_constants.dart';
import 'package:mivro/features/home/providers/product_search_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

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
    final detailState = ref.watch(productDetailProvider);

    Widget bodyContent;

    if (detailState.isLoading) {
      bodyContent = const Center(
        child: CircularProgressIndicator(color: mivroGreen),
      );
    } else if (detailState.error != null) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                detailState.error!,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (detailState.product != null) {
      bodyContent = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(detailState.product!),
            _buildPositiveNutrients(detailState.product!),
            _buildNegativeNutrients(detailState.product!),
            _buildNovaGroup(detailState.product!),
            _buildHealthRisks(detailState.product!),
            _buildRecommendation(detailState.product!),
            const SizedBox(height: 24),
          ],
        ),
      );
    } else {
      bodyContent = const Center(child: Text('No product data available'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: bodyContent,
    );
  }

  Widget _buildProductHeader(Map<String, dynamic> product) {
    final imageUrl = _getProductImageUrl(product);
    final productName = product['product_name'] ?? 'Unknown Product';
    final brands = product['brands'] ?? '';
    final nutriscoreScore = product['nutriscore_score'];
    final nutriscoreGrade = product['nutriscore_grade'];
    final nutriscoreColor = product['nutriscore_grade_color'] ?? '#757575';
    final nutriscoreAssessment = product['nutriscore_assessment'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: mivroGray,
                        child: const Icon(
                          Icons.fastfood,
                          color: mivroGreen,
                          size: 60,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: mivroGray,
                    child: const Icon(
                      Icons.fastfood,
                      color: mivroGreen,
                      size: 60,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (brands.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    brands,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
                if (nutriscoreScore != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: mivroGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                nutriscoreColor.replaceFirst('#', '0xFF'),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$nutriscoreScore/100',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (nutriscoreAssessment.isNotEmpty)
                              Text(
                                nutriscoreAssessment,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                        if (nutriscoreGrade != null) ...[
                          const Spacer(),
                          Text(
                            nutriscoreGrade.toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: mivroGreen,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositiveNutrients(Map<String, dynamic> product) {
    final nutrients = product['nutriments']?['positive_nutrient'] as List?;
    if (nutrients == null || nutrients.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      title: 'Positive Nutrients',
      child: Column(
        children: nutrients.map((nutrient) {
          return _buildNutrientItem(
            nutrient['name'] ?? 'Unknown',
            nutrient['quantity'] ?? 'N/A',
            Colors.green,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNegativeNutrients(Map<String, dynamic> product) {
    final nutrients = product['nutriments']?['negative_nutrient'] as List?;
    if (nutrients == null || nutrients.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      title: 'Negative Nutrients',
      child: Column(
        children: nutrients.map((nutrient) {
          return _buildNutrientItem(
            nutrient['name'] ?? 'Unknown',
            nutrient['quantity'] ?? 'N/A',
            Colors.red,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNutrientItem(String name, String quantity, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            quantity,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNovaGroup(Map<String, dynamic> product) {
    final novaGroup = product['nova_group'];
    final novaGroupName = product['nova_group_name'];

    if (novaGroup == null || novaGroupName == null) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      title: 'Nova Group',
      child: Row(
        children: [
          Image.asset(
            'assets/icons/food/$novaGroup.png',
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              novaGroupName,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRisks(Map<String, dynamic> product) {
    final healthRisk = product['health_risk'];
    if (healthRisk == null) return const SizedBox.shrink();

    final warnings = healthRisk['ingredient_warnings'] as List?;
    if (warnings == null || warnings.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      title: 'Health Risks',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings.map((warning) {
          dynamic warningData;
          if (warning is String) {
            try {
              warningData = json.decode(warning);
            } catch (e) {
              warningData = {'issue': warning, 'reasoning': ''};
            }
          } else if (warning is Map) {
            warningData = warning;
          } else {
            warningData = {'issue': warning.toString(), 'reasoning': ''};
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warningData['issue'] ?? 'Health Concern',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                if (warningData['reasoning'] != null &&
                    warningData['reasoning'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    warningData['reasoning'],
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendation(Map<String, dynamic> product) {
    final recommendation = product['recommended_product'];
    if (recommendation == null) return const SizedBox.shrink();

    final imageUrl = _getProductImageUrl(recommendation);
    final productName = recommendation['product_name'] ?? 'Alternative product';
    final brands = recommendation['brands'] ?? '';

    return _buildSection(
      title: 'Recommendation',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mivroGreen.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: mivroGray,
                          child: const Icon(
                            Icons.fastfood,
                            color: mivroGreen,
                            size: 30,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: mivroGray,
                      child: const Icon(
                        Icons.fastfood,
                        color: mivroGreen,
                        size: 30,
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
                      fontSize: 14,
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
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
