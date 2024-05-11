
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class Product {
  final String? name;
  final String? description;
  final String? url_image;
  final num? price;
  final num? quantity;
  final String? category;

  Product({
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
      if (url_image != null) "url_image": url_image,
      if (price != null) "price": price,
      if (quantity != null) "quantity": quantity,
      if (category != null) "category": category,
    };
  }
}

Future<String> _getImageUrl(String url) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(url);
  final imageUrl = await imageRef.getDownloadURL();
  return imageUrl;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Firestore Example',
      home: MyHomePage(),
    );
  }
}

Future<String> imageUrlFuture(item) {
  return item.getUrl(item.url_image ?? '');
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Example'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          }
          List<Product> products = snapshot.data!.docs.map((doc) {
            return Product.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: Column(
                  children: [
                    FutureBuilder<String>(
                      future: _getImageUrl(products[index].url_image ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    //const ImageFromFirestore(),
                    //Image.network(await products[index].getUrl() as String),
                    //Image.network(storageRef.child(products[index].url_image as String) as String ),
                    //Image.network(getUrl(products[index].url_image) as String),
                    Text(products[index].name ?? ''),
                    Text('Price: ${products[index].price ?? 0}'),
                    //Image.network(products[index].url_image ?? 'https://cdn-icons-png.flaticon.com/512/4143/4143218.png'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*class ImageFromFirestore extends StatelessWidget {
  const ImageFromFirestore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }


}*/
