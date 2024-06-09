import 'package:cloud_firestore/cloud_firestore.dart';

class Category_products {
  String name;
  String url_image;

  Category_products({
    required this.name,
    required this.url_image,
  });

  factory Category_products.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Category_products(
      name: data?['name'],
      url_image: data?['url_image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "url_image": url_image,
    };
  }
}
