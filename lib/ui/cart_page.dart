import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final productId = cartItems.keys.toList()[index];
          final quantity = cartItems[productId];

          return ListTile(
            title: Text('Товар ID: $productId'),
            subtitle: Text('Количество: $quantity'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                cartProvider.removeFromCart(productId);
              },
            ),
          );
        },
      ),
    );
  }
}
