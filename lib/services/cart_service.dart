import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> _cartItems = {};

  Map<String, int> get cartItems => _cartItems;

  void addToCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! + 1;
    } else {
      _cartItems[productId] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! - 1;
      if (_cartItems[productId] == 0) {
        _cartItems.remove(productId);
      }
      notifyListeners();
    }
  }
}
