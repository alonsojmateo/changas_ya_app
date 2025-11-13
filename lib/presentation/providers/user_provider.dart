import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/core/data/profile_repository.dart';
import 'package:changas_ya_app/core/Services/firebase_storage_service.dart';


/// Provider base de Firestore
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

/// Proveedor del UID del usuario actual (por ahora un mock o auth real)
final currentUserIdProvider = StateProvider<String>((ref) => 'test-user-uid');

/// Notifier que maneja un solo perfil
class UserNotifier extends StateNotifier<Profile?> {
  final String _currentUserId;
  final FirebaseFirestore _db;
  final ProfileRepository _repo;
  final StorageService _storage;

  UserNotifier(this._currentUserId, this._db)
      : _repo = ProfileRepository(_db),
        _storage = StorageService(),
        super(null);

  /// Cargar perfil desde Firestore
  Future<void> fetchUserProfile() async {
    try {
      final profile = await _repo.fetchProfileById(_currentUserId);
      state = profile;
    } catch (e) {
      print('❌ Error al obtener perfil: $e');
      state = null;
    }
  }

  /// Actualizar la foto de perfil
  Future<void> updateProfileImage(File file) async {
    if (state == null) return;

    try {
      final imageUrl = await _storage.uploadUserImage(file, _currentUserId);
      await _repo.updateProfilePhoto(_currentUserId, imageUrl);

      // Actualiza el estado local
      state = Profile(
        uid: state!.uid,
        name: state!.name,
        email: state!.email,
        isWorker: state!.isWorker,
        phone: state!.phone,
        address: state!.address,
        photoUrl: imageUrl,
        opinions: state!.opinions,
        trades: state!.trades,
      );
    } catch (e) {
      print('❌ Error al actualizar foto: $e');
      rethrow;
    }
  }
}

/// Proveedor principal del perfil del usuario actual
final userProvider = StateNotifierProvider<UserNotifier, Profile?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  final notifier = UserNotifier(userId, db);
  notifier.fetchUserProfile(); // 🔥 carga automática al iniciar

  return notifier;
});
