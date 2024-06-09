import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_store/widgets/product_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isProductFormVisible = false;

  void _toggleProductFormVisibility() {
    setState(() {
      _isProductFormVisible = !_isProductFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const SignOutButton(),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                              'https://cdn-icons-png.flaticon.com/256/1077/1077114.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(width: 200, height: 200, child: Image.asset('icon2.jpg')),
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ElevatedButton(
                onPressed: _toggleProductFormVisibility,
                child: Text(_isProductFormVisible
                    ? 'Hide Product Form'
                    : 'Show Product Form'),
              ),
              Visibility(
                visible: _isProductFormVisible,
                child: const MyForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
