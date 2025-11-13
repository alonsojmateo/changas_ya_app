import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../Domain/Profile/profile.dart';
import '../../core/data/profile_repository.dart';
import '../../core/Services/firebase_storage_service.dart';

/// Notifier que maneja un solo perfil
class UserNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final String? _currentUserId;
  final FirebaseFirestore _db;
  final ProfileRepository _repo;
  final StorageService _storage;

  UserNotifier(this._currentUserId, this._db)
      : _repo = ProfileRepository(_db),
        _storage = StorageService(),
        super(const AsyncValue.loading()) {
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      state = const AsyncValue.data(null);
    } else {
      fetchUserProfile();
    }
  }

  /// Cargar perfil desde Firestore
  Future<void> fetchUserProfile() async {
    if (_currentUserId == null) return;
    try {
      final profile = await _repo.fetchProfileById(_currentUserId!);
      if (profile != null) {
        state = AsyncValue.data(profile);
      } else {
        state = AsyncValue.error('Perfil no encontrado', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Actualizar foto de perfil (móvil)
  Future<void> updateProfileImage(File file) async {
    if (_currentUserId == null) return;
    try {
      final imageUrl = await _storage.uploadUserImage(file, _currentUserId!);
      await _repo.updateProfilePhoto(_currentUserId!, imageUrl);

      final current = state.value;
      if (current != null) {
        final updated = current.copyWith(photoUrl: imageUrl);
        state = AsyncValue.data(updated);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Actualizar foto de perfil (web)
  Future<void> updateProfileImageWeb(XFile file) async {
    if (_currentUserId == null) return;
    try {
      final imageUrl = await _storage.uploadUserImageWeb(file, _currentUserId!);
      await _repo.updateProfilePhoto(_currentUserId!, imageUrl);

      final current = state.value;
      if (current != null) {
        final updated = current.copyWith(photoUrl: imageUrl);
        state = AsyncValue.data(updated);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Provider que expone UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<Profile?>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final db = FirebaseFirestore.instance;
  return UserNotifier(userId, db);
});





