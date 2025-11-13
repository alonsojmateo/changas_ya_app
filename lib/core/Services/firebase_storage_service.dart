import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadUserImage(File imageFile, String userId) async {
    final ref = _storage.ref().child('user_profiles/$userId/profile.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String> uploadUserImageWeb(XFile pickedFile, String userId) async {
    final ref = _storage.ref().child('user_profiles/$userId/profile.jpg');
    final bytes = await pickedFile.readAsBytes();
    await ref.putData(Uint8List.fromList(bytes));
    return await ref.getDownloadURL();
  }
}
