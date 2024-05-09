import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  String address;
  Timestamp date_delivery;
  String id_order;
  String status;

  Delivery({
    required this.address,
    required this.date_delivery,
    required this.id_order,
    this.status = 'unknown',
  });

  factory Delivery.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Delivery(
      address: data?['address'],
      date_delivery: data?['date_delivery'],
      id_order: data?['id_order'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "address": address,
      "date_delivery": date_delivery,
      "id_order": id_order,
      "status": status,
    };
  }
}
