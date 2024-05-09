import 'package:cloud_firestore/cloud_firestore.dart';

class Manufacturer {
  String name;
  String contact;

  Manufacturer({required this.name, required this.contact});

  factory Manufacturer.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Manufacturer(
      name: data?['name'],
      contact: data?['contact'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "contact": contact,
    };
  }
}
