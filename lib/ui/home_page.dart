import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Shop'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profile'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Cart'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Favourite Products'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ApplicationState> (
        builder: (context, appState, _) => Column(
          children: [
            Image.network(''),
          ],
        ),
      ),

      /*: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> categories = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(category: category),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(category['url_image'], errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.network("https://static.thenounproject.com/png/101469-200.png");
                        },),
                        Text(category['name']),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),*/
    );
  }
}


/*
body: StreamBuilder(
stream: FirebaseFirestore.instance.collection('categories').snapshots(),
builder: (context, snapshot) {
if (snapshot.hasData) {
List<QueryDocumentSnapshot> categories = snapshot.data!.docs;
return GridView.builder(
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
),
itemCount: categories.length,
itemBuilder: (context, index) {
QueryDocumentSnapshot category = categories[index];
return GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => CategoryPage(category: category),
),
);
},
child: Card(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Image.network(category['url_image'], errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
return Image.network("https://static.thenounproject.com/png/101469-200.png");
},),
Text(category['name']),
],
),
),
);
},
);
} else {
return const Center(
child: CircularProgressIndicator(),
);
}
},
),*/
