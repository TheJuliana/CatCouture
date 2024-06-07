import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/functions.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(255, 249, 249, 1.0),
      elevation: 5,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductListPage(category: category.name),
          //   ),
          // );
        },
        child: SizedBox(
          width: 150,
          height: 250,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: FutureBuilder<String>(
                  future: getImageUrl(widget.product.url_image ?? ''),
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
                    widget.product.name ?? 'product name is unknown',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              if (_quantity == 0)
                ElevatedButton(
                  onPressed: _incrementQuantity,
                  style: ElevatedButton.styleFrom(
                    //foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(
                        248, 248, 248, 1.0), // Цвет текста кнопки
                    elevation: 5, // Высота тени кнопки
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // Закругление углов
                      side: const BorderSide(
                          color: Color.fromRGBO(73, 73, 73, 1.0),
                          width: 0.7), // Цвет и толщина рамки
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
                      onPressed: _decrementQuantity,
                    ),
                    Text('$_quantity'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementQuantity,
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
