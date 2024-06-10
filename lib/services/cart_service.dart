import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  Map<Product, int> _cartItems = {}; // Используем Map

  Map<Product, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      // Если товар уже есть в корзине, увеличиваем его количество на 1
      _cartItems[product] = (_cartItems[product] ?? 0) + 1;
    } else {
      // Иначе добавляем товар в корзину с количеством 1
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product)) {
      // Если товар есть в корзине, уменьшаем его количество на 1
      _cartItems[product] = (_cartItems[product] ?? 0) - 1;
      if (_cartItems[product] == 0) {
        // Если количество стало равно 0, удаляем товар из корзины
        _cartItems.remove(product);
      }
      notifyListeners();
    }
  }

  int getTotalItems() {
    // Вычисляем общее количество товаров в корзине
    return _cartItems.values.fold(0, (prev, quantity) => prev + quantity);
  }

  double getTotalPrice(List<Product> products) {
    double totalPrice = 0;
    for (var entry in _cartItems.entries) {
      final productEntry = entry.key;
      final quantity = entry.value;
      final product = products.firstWhere((product) => product == productEntry,
          orElse: () => Product(id: '', name: '', price: 0));
      totalPrice += (product.price ?? 0) * quantity;
    }
    return totalPrice;
  }
}
