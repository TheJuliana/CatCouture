import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Order {
  Timestamp date_order;
  String id_customer;
  List<Reference> items;
  int total;

  Order({
    required this.date_order,
    required this.id_customer,
    required this.items,
    required this.total,
  });

  factory Order.fromFirestore( DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Order(
        date_order: data?['date_order'],
        id_customer: data?['id_customer'],
        items: data?['items'],
        total: data?['total'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "date_order": date_order,
      "id_customer": id_customer,
      "items": items,
      "total": total,
    };
  }
}