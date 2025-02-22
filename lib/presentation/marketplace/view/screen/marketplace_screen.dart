import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mivro/presentation/marketplace/model/item.dart';
import 'package:mivro/presentation/marketplace/provider/cart_count_provider.dart';
import 'package:mivro/presentation/marketplace/view/screen/buy_product.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreen();
}

class _MarketplaceScreen extends ConsumerState<MarketplaceScreen> {
  var coins = 1000;

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(cartCountProvider);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Marketplace',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                Container(
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 9,
                        top: 6,
                        child: Text(
                          '$count',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10),
                Text(
                  coins.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Image.asset(
                  'assets/app-icons/coin.png',
                  height: 30,
                  width: 30,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuyProductscreen(idx: index)));
                  },
                  leading: Image.asset(items[index]['image']),
                  title: Text(items[index]['name']),
                  subtitle: Row(
                    children: [
                      Image.asset(
                        'assets/app-icons/coin.png',
                        width: 20,
                      ),
                      Text('${items[index]['price']}')
                    ],
                  ),
                  trailing: Text(
                    items[index]['rating'],
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: items[index]['color']),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
