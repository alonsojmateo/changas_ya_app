import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';
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

  JobNotifier(this._currentClientId, this._db) : super([]) {
    // Evitamos que se haga la primera carga porque puede estar trayendo el user 
    if (_currentClientId.isNotEmpty && _currentClientId != 'invitado') {
      getPublishedJobsByClient();
    }
  }

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

  Future<void> assignJob(String jobId, String workerId, double budgetManPower, double budgetSpares) async {
    try {
      final jobRef = _db.collection('trabajos').doc(jobId);

      await jobRef.update({
        'status': 'En marcha',
        'workerId': workerId,
        'budgetManPower': budgetManPower,
        'budgetSpares': budgetSpares,
      });
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al asignar el trabajo $jobId al worker $workerId: $e');
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

  Future<int> countJobsByWorkerId(String workerId) async {
    try {
      final Query query = _db.collection('trabajos')
        .where('workerId', isEqualTo: workerId)
        .where('status', isEqualTo: 'Finalizado');
      final aggregateSnapshot = await query.count().get();
      final int? totalJobs = aggregateSnapshot.count; 
      return totalJobs ?? 0;
    } catch (e) {
      print("Error desconocido al contar trabajos: $e");
      return 0;
    }
  }

  Future<void> endJob(String jobId) async {
    try {
      final jobRef = _db.collection('trabajos').doc(jobId);
      await jobRef.update({
        'status': 'Finalizado',
        'dateEnd': DateTime.now()
      });
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al finalizar el trabajo $jobId');
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentUserIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  return JobNotifier(clientId, db);
});

final totalJobsProvider = FutureProvider.family<int, String>((ref, workerId) async {
  final jobNotifier = ref.read(jobProvider.notifier);
  return jobNotifier.countJobsByWorkerId(workerId);
});