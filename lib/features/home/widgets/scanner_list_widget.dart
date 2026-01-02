import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mivro/features/home/providers/product_details_provider.dart';
import 'package:mivro/features/home/providers/product_search_provider.dart';
import 'package:mivro/core/hex_color.dart';
import 'package:mivro/features/home/widgets/scanner_button_widgets.dart';
import 'package:mivro/features/home/widgets/scanner_error_widget.dart';
import 'package:mivro/features/home/widgets/product_search_widget.dart';
import 'package:mivro/features/home/widgets/product_search_results.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerListWidget extends ConsumerStatefulWidget {
  const ScannerListWidget({super.key});

  @override
  ConsumerState<ScannerListWidget> createState() => _ScannerListWidgetState();
}

class _ScannerListWidgetState extends ConsumerState<ScannerListWidget> {
  MobileScannerController? controller;
  void _initializeController() {
    if (controller == null) {
      controller = MobileScannerController(torchEnabled: false);
      setState(() {});
    }
  }

  Icon favorite = const Icon(Icons.favorite_border);
  ValueNotifier<bool> showMorePositives = ValueNotifier(false);
  ValueNotifier<bool> showMoreIngredients = ValueNotifier(false);
  ValueNotifier<bool> showMoreNegatives = ValueNotifier(false);

  @override
  void initState() {
    _initializeController();
    controller!.stop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildIngredientRow(
      String name,
      String percentage,
      String imageString,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageString == 'milk-chocolate')
              Image.asset(
                'assets/icons/food/chocolate.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString == 'corn-syrup')
              Image.asset(
                'assets/icons/food/corn.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString == 'peanuts')
              Image.asset(
                'assets/icons/food/nuts.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString != 'peanuts' &&
                imageString != 'corn-syrup' &&
                imageString != 'milk-chocolate')
              Image.asset(
                'assets/icons/food/$imageString.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Text(
              percentage,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    Widget buildNutritionRow(
      String title,
      String amount,
      String description,
      String color,
      String imageString,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageString == 'sugars')
              Image.asset(
                'assets/icons/food/sugars.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString == 'carbohydrates')
              Image.asset(
                'assets/icons/food/carbohydrates.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString == 'proteins')
              Image.asset(
                'assets/icons/food/protein.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            if (imageString != 'proteins' &&
                imageString != 'carbohydrates' &&
                imageString != 'sugars')
              Image.asset(
                'assets/icons/food/$imageString.png',
                width: 30,
                height: 30,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        'assets/icons/misc/no-image.png',
                        width: 30,
                        height: 30,
                      );
                    },
              ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 16,
                    color: myColorFromHex(color),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.circle, color: myColorFromHex(color), size: 12),
              ],
            ),
          ],
        ),
      );
    }

    Future<void> launchUrlExternal(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }

    Widget devDetails(Map<String, dynamic> result) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.only(
              top: 5,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            color: Colors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.pop(context);
                          controller!.start();
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Powered by ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'OpenFoodFacts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(text: ' + '),
                            TextSpan(
                              text: 'Google Gemini',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'App\n',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '• Search Type: ${result['search_type']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Search Response: ${result['search_response']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Response Time: ${result['response_time']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Response Size: ${result['response_size']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Search Date: ${result['search_date']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Search Time: ${result['search_time']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Product\n',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '• ID: ${result['_id']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Total Nutrients: ${result['total_nutriments']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Total Ingredients: ${result['ingredients_n']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Total Additives: ${result['additives_n']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Total Health Risks: ${result['total_health_risks']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Warning\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'The information provided is for general guidance only and should not be considered medical advice. Always seek professional advice for important health decisions.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        '© 2024 Areeb Ahmed, Shivansh Karan, Rishi Chirchi. All rights reserved.',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => launchUrlExternal(
                              'https://github.com/1MindLabs/mivro-docs/blob/main/LICENSE',
                            ),
                            child: const Text(
                              'License',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => launchUrlExternal(
                              'https://github.com/1MindLabs/mivro-docs/blob/main/README.md',
                            ),
                            child: const Text(
                              'License',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget details(Map<String, dynamic> result) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.only(
              top: 5,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            color: Colors.white,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.flag_outlined),
                        iconSize: 20,
                        onPressed: () {},
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return IconButton(
                            icon: favorite,
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                favorite = Icon(
                                  favorite.icon == Icons.favorite
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: favorite.icon == Icons.favorite
                                      ? Colors.black
                                      : Colors.red,
                                );
                              });
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.ios_share_rounded),
                        iconSize: 20,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.pop(context);
                          controller!.start();
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => devDetails(result),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          result['selected_images']['en'] ?? '',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result['product_name'] ?? 'name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              result['brands'] ?? 'brand',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${result['primary_score']?['score'] ?? 'N/A'}/100',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: myColorFromHex(
                                      result['primary_score']?['grade_color'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  result['primary_score']?['grade']
                                          ?.toString()
                                          .toUpperCase() ??
                                      'N/A',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: myColorFromHex(
                                      result['primary_score']?['grade_color'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              result['primary_score']?['assessment'] ??
                                  'Unknown',
                              style: TextStyle(
                                color: myColorFromHex(
                                  result['primary_score']?['grade_color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Negatives',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ValueListenableBuilder(
                    valueListenable: showMoreNegatives,
                    builder: (context, value, child) {
                      final positiveNutrients =
                          result['nutriments']['negative_nutrient'];
                      final nutrientsCount = positiveNutrients.length;

                      return Column(
                        children: [
                          for (
                            var i = 0;
                            i <
                                (value
                                    ? nutrientsCount
                                    : min(3, nutrientsCount));
                            i++
                          )
                            buildNutritionRow(
                              positiveNutrients[i]['name'],
                              positiveNutrients[i]['quantity'],
                              positiveNutrients[i]['text'],
                              positiveNutrients[i]['color'],
                              positiveNutrients[i]['name']
                                  .toString()
                                  .toLowerCase(),
                            ),

                          if (nutrientsCount > 3)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  showMoreNegatives.value =
                                      !showMoreNegatives.value;
                                },
                                child: Text(
                                  showMoreNegatives.value
                                      ? 'Show Less'
                                      : 'Show More',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Positives',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ValueListenableBuilder(
                    valueListenable: showMorePositives,
                    builder: (context, value, child) {
                      final positiveNutrients =
                          result['nutriments']['positive_nutrient'];
                      final nutrientsCount = positiveNutrients.length;

                      return Column(
                        children: [
                          for (
                            var i = 0;
                            i <
                                (value
                                    ? nutrientsCount
                                    : min(3, nutrientsCount));
                            i++
                          )
                            buildNutritionRow(
                              positiveNutrients[i]['name'],
                              positiveNutrients[i]['quantity'],
                              positiveNutrients[i]['text'],
                              positiveNutrients[i]['color'],
                              positiveNutrients[i]['name']
                                  .toString()
                                  .toLowerCase(),
                            ),

                          if (nutrientsCount > 3)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  showMorePositives.value =
                                      !showMorePositives.value;
                                },
                                child: Text(
                                  showMorePositives.value
                                      ? 'Show Less'
                                      : 'Show More',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: showMoreIngredients,
                    builder: (context, value, child) {
                      final ingredients = result['ingredients'];
                      final ingredientsCount = ingredients.length;

                      return Column(
                        children: [
                          for (
                            var i = 0;
                            i <
                                (value
                                    ? ingredientsCount
                                    : min(3, ingredientsCount));
                            i++
                          )
                            buildIngredientRow(
                              ingredients[i]['name'],
                              ingredients[i]['percentage'],
                              ingredients[i]['icon'].toLowerCase(),
                            ),

                          if (ingredientsCount > 3)
                            TextButton(
                              onPressed: () {
                                showMoreIngredients.value =
                                    !showMoreIngredients.value;
                              },
                              child: Text(
                                value ? 'Show Less' : 'Show More',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Nova Group",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/food/${result['nova_group']}.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 8),
                        Text(result['nova_group_name']!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Health Risks",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/misc/health-risk.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              for (var risk
                                  in result['health_risk']['ingredient_warnings'])
                                Text('• $risk'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Recommendation",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (result['recommended_product']['brands'] != null) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return details(result['recommended_product']);
                          },
                        );
                      }
                    },
                    child: result['recommended_product']['brands'] != null
                        ? Row(
                            children: [
                              Image.network(
                                result['recommended_product']['selected_images']['en'],
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result['recommended_product']['product_name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    result['recommended_product']['brands'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${result['recommended_product']['primary_score']?['score'] ?? 'N/A'}/100',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: myColorFromHex(
                                            result['recommended_product']['primary_score']?['grade_color'],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        result['recommended_product']['primary_score']?['grade']
                                                ?.toString()
                                                .toUpperCase() ??
                                            'N/A',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: myColorFromHex(
                                            result['recommended_product']['primary_score']?['grade_color'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    result['recommended_product']['primary_score']?['assessment'] ??
                                        'Unknown',
                                    style: TextStyle(
                                      color: myColorFromHex(
                                        result['recommended_product']['primary_score']?['grade_color'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Image.asset(
                                'assets/icons/misc/no-database.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                result['recommended_product']['product_name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget buildBarcodesListView() {
      return StreamBuilder<BarcodeCapture>(
        stream: controller!.barcodes,
        builder: (context, snapshot) {
          final barcodes = snapshot.data?.barcodes;

          if (barcodes == null || barcodes.isEmpty) {
            return const SizedBox.shrink();
          }

          String barcode = barcodes.first.rawValue.toString();
          ("Scanned Barcode: $barcode");

          controller!.stop();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return FutureBuilder<Map<String, dynamic>>(
                  future: ref
                      .read(productDetailsProvider.notifier)
                      .getProductDetails(barcode),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return DraggableScrollableSheet(
                        expand: false,
                        builder: (context, scrollController) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return DraggableScrollableSheet(
                        expand: false,
                        builder: (context, scrollController) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      var result = snapshot.data!;
                      return details(result);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "No product details found.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          });

          controller!.start();

          return const SizedBox.shrink();
        },
      );
    }

    return Stack(
      children: [
        MobileScanner(
          onDetect: (barcodeCapture) {},
          controller: controller,
          scanWindow: Rect.fromLTWH(
            (MediaQuery.of(context).size.width - 400) / 2,
            (MediaQuery.of(context).size.height - 310) / 2,
            400,
            150,
          ),
          errorBuilder: (context, error) {
            return ScannerErrorWidget(error: error);
          },
          fit: BoxFit.cover,
        ),
        Consumer(
          builder: (context, ref, child) {
            final searchState = ref.watch(productSearchProvider);
            final hasResults =
                searchState.products.isNotEmpty || searchState.error != null;

            if (hasResults) {
              return const ProductSearchResults();
            }

            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        ClipPath(
                          clipper: _CutOutClipper(
                            holeSize: const Size(400, 150),
                            position: Offset(
                              (constraints.maxWidth - 400) / 2,
                              (constraints.maxHeight - 150) / 2,
                            ),
                          ),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 150,
                            width: 400,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 172, 49, 40),
                                width: 2,
                              ),
                            ),
                            child: Lottie.asset(
                              'assets/animations/scanner.json',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 150,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleFlashlightButton(controller: controller!),
                      const Text(
                        'Flash',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      AnalyzeImageFromGalleryButton(controller: controller!),
                      const Text(
                        'Gallery',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [Expanded(child: buildBarcodesListView())],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: ProductSearchWidget(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }
}

class _CutOutClipper extends CustomClipper<Path> {
  final Size holeSize;
  final Offset position;

  _CutOutClipper({required this.holeSize, required this.position});

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(
        Rect.fromLTWH(
          position.dx,
          position.dy,
          holeSize.width,
          holeSize.height,
        ),
      )
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
