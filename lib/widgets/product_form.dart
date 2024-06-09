import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String? _selectedCategory;
  List<String> _categories = [];
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImageData;
  String? _fileName;
  String? _name;
  String? _description;
  num? _price;
  num? _quantity;
  String? _category;
  String? _url_image;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    CollectionReference categoriesRef = FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await categoriesRef.get();
    List<String> categories = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _getImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final Uint8List fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      setState(() {
        _webImageData = fileBytes;
        _fileName = fileName;
      });
    } else {
      // User canceled picking file
      print("User canceled file picking.");
    }
  }

  Future<void> _uploadImage() async {
    if (_fileName != null && _webImageData != null) {
      try {
        final storageRef =
            FirebaseStorage.instance.ref().child("products_images/$_fileName");
        final uploadTask = storageRef.putData(
          _webImageData!,
          SettableMetadata(
              contentType: 'image/jpeg'), // тип контента "image/jpeg"
        );

        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _url_image = downloadUrl;
        });
        print("Download URL: $downloadUrl");
      } catch (e) {
        print("Error uploading file: $e");
      }
    }
  }

  Future<void> _uploadProduct() async {
    await _uploadImage();

    if (_url_image == null) {
      print("Image URL is null, aborting product upload.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _name,
        'description': _description,
        'url_photo': _url_image,
        'price': _price,
        'quantity': _quantity,
        'category': _category,
      });
      print('Product successful uploaded');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product successful uploaded'),
        ),
      );
    } catch (e) {
      print("Error uploading product: $e");
    }
  }

  Widget _buildImageWidget() {
    if (_webImageData != null) {
      return Column(
        children: [
          const Text('Selected image:'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(
                _webImageData!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              IconButton(
                icon: const Icon(Icons.close), // Иконка крестика
                onPressed: () {
                  setState(() {
                    _webImageData = null; // Удаляем изображение
                  });
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox(height: 16); // Placeholder for image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Product Name'),
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (value) {
            setState(() {
              _description = value;
            });
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Price'),
          onChanged: (value) {
            setState(() {
              _price = double.parse(value);
            });
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Quantity'),
          onChanged: (value) {
            setState(() {
              _quantity = int.parse(value);
            });
          },
        ),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(labelText: 'Category'),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
              _category = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: _getImage,
          child: const Text('Pick image'),
        ),
        const SizedBox(height: 16),
        _buildImageWidget(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _uploadProduct,
          child: const Text('Upload product'),
        ),
      ],
    );
  }
}
