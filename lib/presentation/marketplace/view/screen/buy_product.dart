import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mivro/presentation/home/provider/product_details_provider.dart';
import 'package:mivro/presentation/marketplace/model/item.dart';
import 'package:mivro/presentation/marketplace/model/result.dart';
import 'package:mivro/presentation/marketplace/provider/cart_count_provider.dart';
import 'package:mivro/utils/hexcolor.dart';

class BuyProductscreen extends ConsumerStatefulWidget {
  final int idx;
  const BuyProductscreen({super.key, required this.idx});

  @override
  ConsumerState<BuyProductscreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends ConsumerState<BuyProductscreen> {
  Icon favorite = const Icon(Icons.favorite_border);
  ValueNotifier<bool> showMorePositives = ValueNotifier(false);
  ValueNotifier<bool> showMoreIngredients = ValueNotifier(false);
  ValueNotifier<bool> showMoreNegatives = ValueNotifier(false);

  Widget _buildIngredientRow(
      String name, String percentage, String imageString) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/food-icons/$imageString.png',
            width: 30,
            height: 30,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset(
                'assets/food-icons/no-image.png', // Fallback image when asset is not found
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

  Widget _buildNutritionRow(String title, String amount, String description,
      String color, String imageString) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/food-icons/$imageString.png',
            width: 30,
            height: 30,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset(
                'assets/food-icons/no-image.png', // Fallback image when asset is not found
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
              Text(description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(amount,
                  style: TextStyle(
                      fontSize: 16,
                      color: myColorFromHex(color),
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(Icons.circle, color: myColorFromHex(color), size: 12),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // getDummyData();
    super.initState();
  }

  Widget details(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 16),
      color: Colors.white,
      child: SingleChildScrollView(
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
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    items[widget.idx]['image'],
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[widget.idx]['name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        result['brands'] ?? 'brand',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/app-icons/coin.png',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            items[widget.idx]['price']?? '10',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle,
                              color:items[widget.idx]['color'],
                              size: 12),
                          const SizedBox(width: 8),
                          Text('${result['nutriscore_score']}/100',
                              style: TextStyle(
                                  color: items[widget.idx]['color'],),),
                          const SizedBox(width: 8),
                          Text(
                              items[widget.idx]['rating']
                                  .toString()
                                  .toUpperCase(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: items[widget.idx]['color'])),
                        ],
                      ),
                      Text(result['nutriscore_assessment'] ?? 'assessment',
                          style: TextStyle(
                              color: items[widget.idx]['color'])),
                    ],
                  )
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
                    // Show either all items or up to 3 items
                    for (var i = 0;
                        i < (value ? nutrientsCount : min(3, nutrientsCount));
                        i++)
                      _buildNutritionRow(
                        positiveNutrients[i]['name'],
                        positiveNutrients[i]['quantity'],
                        positiveNutrients[i]['text'],
                        positiveNutrients[i]['color'],
                        positiveNutrients[i]['name'].toString().toLowerCase(),
                      ),

                    // Conditionally display the button if there are more than 3 items
                    if (nutrientsCount > 3)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            showMoreNegatives.value = !showMoreNegatives.value;
                          },
                          child: Text(
                            showMoreNegatives.value ? 'Show Less' : 'Show More',
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
                    // Show either all items or up to 3 items
                    for (var i = 0;
                        i < (value ? nutrientsCount : min(3, nutrientsCount));
                        i++)
                      _buildNutritionRow(
                        positiveNutrients[i]['name'],
                        positiveNutrients[i]['quantity'],
                        positiveNutrients[i]['text'],
                        positiveNutrients[i]['color'],
                        positiveNutrients[i]['name'].toString().toLowerCase(),
                      ),

                    // Conditionally display the button if there are more than 3 items
                    if (nutrientsCount > 3)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            showMorePositives.value = !showMorePositives.value;
                          },
                          child: Text(
                            showMorePositives.value ? 'Show Less' : 'Show More',
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
                    // Show the first 3 items or all items based on 'showMoreIngredients'
                    for (var i = 0;
                        i <
                            (value
                                ? ingredientsCount
                                : min(3, ingredientsCount));
                        i++)
                      _buildIngredientRow(
                        ingredients[i]['name'],
                        ingredients[i]['percentage'],
                        ingredients[i]['icon'].toLowerCase(),
                      ),

                    // Conditionally display the button only if there are more than 3 ingredients
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
            const Text("Nova Group",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/food-icons/${result['nova_group']}.png',
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 8),
                    Text(result['nova_group_name']!),
                  ],
                )),
            const SizedBox(height: 16),
            const Text("Health Risks",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/health-risk.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        for (var risk in result['health_risk']
                            ['ingredient_warnings'])
                          Text('• $risk')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartCountProvider.notifier).increment();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Add to cart'),
                ),
                Gap(25),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color.fromARGB(255, 241, 72, 60),
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15)),
                  child: const Text(
                    'Buy now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: details(result),
      ),
    );
  }
}
