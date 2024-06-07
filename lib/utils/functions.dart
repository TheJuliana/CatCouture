import 'package:firebase_storage/firebase_storage.dart';

Future<String> getImageUrl(String url) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(url);
  final imageUrl = await imageRef.getDownloadURL();
  return imageUrl;
}