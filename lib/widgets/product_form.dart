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
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _webImageData;
  String? _name;
  String? _description;
  num? _price;
  num? _quantity;
  String? _category;
  String? _url_image;

  Future<void> _getImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final Uint8List fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      // Upload file to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance.ref().child("products_images/$fileName");
        final uploadTask = storageRef.putData(
          fileBytes,
          SettableMetadata(contentType: 'image/jpeg'), // тип контента "image/jpeg"
        );


        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              print("Error during upload: ${TaskState.error}");
              break;
            case TaskState.success:
              print("Upload complete.");
              final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
              _url_image = downloadUrl;
              print("Download URL: $downloadUrl");

              try {
                await FirebaseFirestore.instance.collection('products').add({
                  'name': _name,
                  'description': _description,
                  'url_photo': downloadUrl,
                  'price': _price,
                  'quantity': _quantity,
                  'category': _category,
                });
              } catch (e) {
                print ("Error uploading product: $e");
              }

              break;
          }
        });
      } catch (e) {
        print("Error uploading file: $e");
      }
    } else {
      // User canceled picking file
      print("User canceled file picking.");
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
        TextFormField(
          decoration: const InputDecoration(labelText: 'Category'),
          onChanged: (value) {
            setState(() {
              _category = value;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_url_image != null)
          Column(
            children: [
              const Text('Selected image:'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    _url_image!,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close), // Иконка крестика
                    onPressed: () {
                      setState(() {
                        _url_image = null; // Удаляем изображение
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        else
          const SizedBox(height: 100, width: 100), // Placeholder for image
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _getImage,
          child: const Text('Pick image & Upload product'),
        ),
      ],
    );
  }
}
