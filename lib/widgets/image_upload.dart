import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageUpload extends StatefulWidget {
  final void Function(String) setDownloadURL;

  const ImageUpload({super.key, required this.setDownloadURL});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;


  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_imageFile != null) {
        // Создание ссылки для сохранения изображения в Firebase Storage
        final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Загрузка изображения в Firebase Storage
        await storageRef.putFile(_imageFile!);

        setState(() {
          _isUploading = false;
        });

        // Получение URL загруженного изображения
        String downloadURL = await storageRef.getDownloadURL();
        print('Image uploaded. Download URL: $downloadURL');

        // Далее вы можете использовать URL для отображения или сохранения его в базе данных Firebase Firestore.
        // Передаем downloadURL родительскому виджету
        widget.setDownloadURL(downloadURL);

      } else {
        setState(() {
          _isUploading = false;
        });
        print('No image selected.');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading image: $e');
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _imageFile == null
                  ? const Text('No image selected.')
                  : Image.file(_imageFile!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Upload Image'),
              ),
            ],
          ),
        ],
      ),

    );
  }
}