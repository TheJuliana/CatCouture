import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../services/cart_service.dart';
import '../ui/product_detail_page.dart';
import '../utils/functions.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final isInCart = cartProvider.cartItems.containsKey(product);

    final quantity = cartProvider.cartItems[product] ?? 0;

    return Card(
      color: const Color.fromRGBO(255, 249, 249, 1.0),
      elevation: 5,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        child: SizedBox(
          width: 150,
          height: 250,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: FutureBuilder<String>(
                  future: getImageUrl(product.url_image ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product.name ?? 'product name is unknown',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text('${product.price.toString()} \$'),
              if (!isInCart)
                ElevatedButton(
                  onPressed: () {
                    cartProvider.addToCart(product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color.fromRGBO(73, 73, 73, 1.0),
                        width: 0.7,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Color.fromRGBO(73, 73, 73, 1.0)),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cartProvider.removeFromCart(product);
                      },
                    ),
                    Text('$quantity'), // Отображаем количество товаров
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        cartProvider.addToCart(product);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
