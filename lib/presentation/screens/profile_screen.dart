import 'dart:io';
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
      final file = File(pickedFile.path);
      try {
        await ref
            .read(userProvider.notifier)
            .updateProfileImage(file); // 👈 delegamos al provider
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen actualizada correctamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
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
                  backgroundImage: (user.photoUrl != null &&
                          user.photoUrl!.startsWith('http'))
                      ? NetworkImage(user.photoUrl!)
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  onPressed: () => _changeProfileImage(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(user.name, style: textStyle.titleLarge),
            Text(user.email),
            if (user.address != null) Text(user.address!),
            if (user.phone != null) Text(user.phone!),
            const SizedBox(height: 20),
            Text('Opiniones:', style: textStyle.titleMedium),
            const SizedBox(height: 10),
            ...user.opinions.map(
              (opinion) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(opinion.comment),
                  trailing: Text(
                    '${opinion.rating} ⭐',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
