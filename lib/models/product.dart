import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String? name;
  final String? description;
  final String? url_image;
  final num? price;
  final num? quantity;
  final String? category;

  Product({
    required this.id,
    this.name,
    this.description,
    this.url_image,
    this.price,
    this.quantity,
    this.category,
  });

  factory Product.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Product(
      id: snapshot.id,
      name: data?['name'],
      description: data?['description'] ?? 'null description',
      url_image: data?['url_photo'] ?? '',
      price: data?['price'] ?? 0.0,
      quantity: data?['quantity'] ?? 1,
      category: data?['category'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (url_image != null) "url_photo": url_image,
      if (price != null) "price": price,
      if (quantity != null) "quantity": quantity,
      if (category != null) "category": category,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Product otherProduct = other as Product;
    return id == otherProduct.id;
  }

  @override
  int get hashCode => id.hashCode;
}
