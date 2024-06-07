import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../widgets/product_card.dart'; // Предполагается, что у вас есть модель продукта

class ProductListPage extends StatelessWidget {
  final String category;

  const ProductListPage({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in $category'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          List<Product> products = snapshot.data!.docs.map((doc) {
            return Product.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();

          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(products.length, (index) {
                  return ProductCard(product: products[index]);
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
