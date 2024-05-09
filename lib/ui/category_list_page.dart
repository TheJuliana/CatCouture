import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_image/universal_image.dart';
import '../firebase_options.dart';
import '../models/category.dart';

Future<String> _getImageUrl(String url) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(url);
  final imageUrl = await imageRef.getDownloadURL();
  return imageUrl;
}

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  int _numCategories = 0;
  @override
  void initState() {
    super.initState();
    _getNumCategories();
  }

  void _getNumCategories() async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await usersRef.get();
    setState(() {
      _numCategories = querySnapshot.size;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData) {
                return const Text('No data available');
              }
              List<Category_products> categories = snapshot.data!.docs.map((doc) {
                return Category_products.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>);
              }).toList();
        
              return Center(
                child: Wrap(
                  spacing: 10, // Расстояние между элементами по горизонтали
                  runSpacing: 10, // Расстояние между строками
                  children: List.generate(_numCategories, (index) {
                    return Card(
                      elevation: 5,
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: FutureBuilder<String>(
                                future: _getImageUrl(categories[index].url_image ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.network(snapshot.data!, fit: BoxFit.cover);
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                            Flexible(child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(categories[index].name),
                            )),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
        
            }),
      ),
    );
  }
}

