
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../utils/functions.dart';



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
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('categories');
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
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return const Text('No data available');
              }
              List<Category_products> categories =
                  snapshot.data!.docs.map((doc) {
                return Category_products.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>);
              }).toList();

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    spacing: 10, // Расстояние между элементами по горизонтали
                    runSpacing: 10, // Расстояние между строками
                    children: List.generate(_numCategories, (index) {
                      return Card(
                        color: const Color.fromRGBO(255, 249, 249, 1.0),
                        elevation: 5,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: SizedBox(
                            width: 150,
                            height: 200,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: FutureBuilder<String>(
                                    future: getImageUrl(
                                        categories[index].url_image ?? ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(snapshot.data!,
                                              fit: BoxFit.cover),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(categories[index].name),
                                )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
