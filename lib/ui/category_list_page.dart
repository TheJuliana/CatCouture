import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

import '../widgets/category_card.dart';

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
        backgroundColor: const Color.fromARGB(255, 255, 110, 188),
        title: const Center(child: Text('Categories')),
      ),
      body: SingleChildScrollView(
        child: CategoryList(numCategories: _numCategories),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final int numCategories;

  const CategoryList({super.key, required this.numCategories});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        }

        List<Category_products> categories = snapshot.data!.docs.map((doc) {
          return Category_products.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(numCategories, (index) {
                return CategoryCard(category: categories[index]);
              }),
            ),
          ),
        );
      },
    );
  }
}