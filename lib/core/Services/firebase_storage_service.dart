import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Sube la imagen a Firebase Storage y devuelve la URL pública
  Future<String> uploadUserImage(File imageFile, String userId) async {
    try {
      final storageRef = _storage.ref().child('user_profiles/$userId/profile.jpg');

      await storageRef.putFile(imageFile);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }
}
