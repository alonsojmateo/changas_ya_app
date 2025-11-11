import 'dart:io';
import 'package:changas_ya_app/core/Services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const String screenName = 'profileScreen';

  Future<void> _changeProfileImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final user = ref.read(userProvider);
      if (user == null) return;

      final file = File(pickedFile.path);
      final storage = StorageService();
      final imageUrl = await storage.uploadUserImage(file, user.getEmail());

      // Actualizamos el usuario con la nueva URL
      user.setFotoUrl(imageUrl);
      ref.read(userProvider.notifier).state = user;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen actualizada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.getFotoUrl().startsWith('http')
                      ? NetworkImage(user.getFotoUrl())
                      : AssetImage(user.getFotoUrl()) as ImageProvider,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  onPressed: () => _changeProfileImage(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(user.getName(), style: textStyle.titleLarge),
            Text(user.getEmail()),
            Text(user.getDireccion()),
            Text(user.getTelefono()),
            const SizedBox(height: 20),
            Text('Opiniones:', style: textStyle.titleMedium),
            const SizedBox(height: 10),
            ...user.getOpiniones().map(
              (opinion) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(opinion.comentario),
                  trailing: Text('${opinion.calificacion} ⭐',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
