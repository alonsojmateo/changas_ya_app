import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentClientIdProvider = StateProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return 'anonymous-user';
});

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

class JobNotifier extends StateNotifier<List<Job>> {
  final String _currentClientId;
  final FirebaseFirestore _db;

  JobNotifier(this._currentClientId, this._db) : super([]);

  Future<void> getPublishedJobsByClient() async {
    try {
      if (_currentClientId == 'anonymous-user') {
        print('⚠️ Usuario no autenticado, no se pueden cargar trabajos');
        state = [];
        return;
      }

      print('🔍 Cargando trabajos para cliente: $_currentClientId');

      final jobsCollection = _db
          .collection('trabajos')
          .withConverter(
            fromFirestore: Job.fromFirestore,
            toFirestore: (Job job, _) => job.toFirestore(),
          );
      final query = jobsCollection.where(
        'clientId',
        isEqualTo: _currentClientId,
      );
      final snapshot = await query.get();
      final jobs = snapshot.docs.map((doc) => doc.data()).toList();

      state = jobs;
      print('✅ Trabajos cargados: ${jobs.length}');
    } catch (e) {
      print('❌ Error al cargar trabajos: $e');
      state = [];
    }
  }

  Future<void> addJob(Map<String, dynamic> jobData) async {
    try {
      if (_currentClientId == 'anonymous-user') {
        throw Exception('Debes iniciar sesión para crear un trabajo');
      }

      final completeJobData = {
        ...jobData,
        'clientId': _currentClientId,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      print('DATOS COMPLETOS QUE SE GUARDAN EN FIREBASE:');
      print(completeJobData);

      await _db.collection('trabajos').add(completeJobData);
      await getPublishedJobsByClient();

      print('Job creado exitosamente por cliente: $_currentClientId');
    } catch (e) {
      print('Error al crear trabajo: $e');
      rethrow;
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentClientIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  return JobNotifier(clientId, db);
});
