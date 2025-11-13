import 'dart:io';
import 'package:flutter/foundation.dart';
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
      try {
        if (kIsWeb) {
          await ref.read(userProvider.notifier).updateProfileImageWeb(pickedFile);
        } else {
          final file = File(pickedFile.path);
          await ref.read(userProvider.notifier).updateProfileImage(file);
        }

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
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Usuario no encontrado')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Mi Perfil')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _changeProfileImage(context, ref),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                    child: user.photoUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Nombre: ${user.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Tipo de usuario: ${user.isWorker ? "Trabajador" : "Cliente"}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                // Trades
                if (user.trades.isNotEmpty) ...[
                  const Text('Oficios / Trades:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: user.trades
                        .map((trade) => Chip(label: Text(trade)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Opiniones
                if (user.opinions.isNotEmpty) ...[
                  const Text('Opiniones:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    children: user.opinions
                        .map(
                          (op) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(op.comment),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < op.rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
