import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_store/firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:online_store/services/auth_service.dart';

import 'package:online_store/ui/category_list_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ui.FirebaseUIAuth.configureProviders([
    ui.EmailAuthProvider(),
  ]);
  runApp(const MyApp());
}

StreamController<bool> isLightTheme = StreamController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          // Цвет фона BottomNavigationBar
          selectedItemColor: Color.fromARGB(255, 255, 110, 188),
          // Цвет активных элементов
          unselectedItemColor: Color.fromARGB(255, 124, 124, 124), // Цвет неактивных элементов
          elevation: 8, // Высота тени
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(208, 208, 208, 1.0), // Цвет стрелочки назад
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Индекс текущей выбранной вкладки

  final List<Widget> _pages = [
    const CategoryListPage(),
    const Text('Корзина'),
    const AuthGate(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SizedBox(width: 40, height: 40, child: Image.asset('icon2.jpg')),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('CatCouture'),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex], // Отображаем текущую страницу
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Обновляем индекс текущей вкладки
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

