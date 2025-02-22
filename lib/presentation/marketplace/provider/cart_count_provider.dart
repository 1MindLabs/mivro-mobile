import 'package:flutter_riverpod/flutter_riverpod.dart';

// CartCountNotifier manages the cart count logic
class CartCountNotifier extends StateNotifier<int> {
  CartCountNotifier() : super(0); // Initialize the cart count to 0

  // Method to increment the cart count
  void increment() => state++;

  // Method to decrement the cart count
  void decrement() {
    if (state > 0) state--;
  }

  // Optional: Method to reset the cart count
  void reset() => state = 0;
}

// Create a StateNotifierProvider for CartCountNotifier
final cartCountProvider = StateNotifierProvider<CartCountNotifier, int>((ref) {
  return CartCountNotifier();
});
