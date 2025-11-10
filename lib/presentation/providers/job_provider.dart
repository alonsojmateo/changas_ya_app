import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentClientIdProvider = StateProvider<String>(
  (ref) => 'test-client-mock',
);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final currentPageProvider = StateProvider<int>((ref) => 0);
final totalJobsCountProvider = StateProvider<int?>((ref) => null);

class JobNotifier extends StateNotifier<List<Job>> {
  final String _currentClientId;
  final FirebaseFirestore _db;
  static const int pageSize = 10;
  DocumentSnapshot? _lastDocumentSnapshot;

  JobNotifier(this._currentClientId, this._db) : super([]);

  DocumentSnapshot? get lastDocumentSnapshot => _lastDocumentSnapshot;

  Future<void> getPublishedJobsByClient() async {
    try {
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
    } catch (e) {
      print('Error al cargar trabajos publicados desde Firebase: $e');
      state = [];
    }
  }

  /// Cuenta el total de trabajos disponibles para trabajadores
  /// Filtra trabajos con estado "Buscando profesional"
  Future<int> countAvailableJobsForWorkers() async {
    try {
      final jobsCollection = _db.collection('trabajos');
      final query = jobsCollection.where('status', isEqualTo: 'Buscando profesional');
      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error al contar trabajos disponibles para trabajadores: $e');
      return 0;
    }
  }

  /// Obtiene trabajos disponibles para trabajadores
  /// Filtra trabajos con estado "Buscando profesional"
  /// Si startAfterDoc es proporcionado, comienza después de ese documento (para la siguiente página)
  /// Si es null, comienza desde el principio (primera página)
  Future<void> getAvailableJobsForWorkers({DocumentSnapshot? startAfterDoc}) async {
    try {
      final jobsCollection = _db
          .collection('trabajos')
          .withConverter(
            fromFirestore: Job.fromFirestore,
            toFirestore: (Job job, _) => job.toFirestore(),
          );

      Query<Job> query = jobsCollection
          .where('status', isEqualTo: 'Buscando profesional')
          .limit(pageSize);

      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      final snapshot = await query.get();
      final jobs = snapshot.docs.map((doc) => doc.data()).toList();
      state = jobs;
      
      // Almacena el último snapshot de documento para paginación
      // Usamos el documento sin el converter como cursor
      if (snapshot.docs.isNotEmpty) {
        final lastDocWithConverter = snapshot.docs.last;
        _lastDocumentSnapshot = await lastDocWithConverter.reference.get();
      } else {
        _lastDocumentSnapshot = null;
      }
    } catch (e) {
      print('Error al cargar trabajos disponibles para trabajadores: $e');
      state = [];
      _lastDocumentSnapshot = null;
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
    } catch (e) {
      print('Error al asignar el trabajo $jobId al worker $workerId: $e');
    }
  }
  
  Future<void> addJob(Map<String, dynamic> jobData) async {
    try {
      final completeJobData = {...jobData, 'clientId': _currentClientId};

      await _db.collection('trabajos').add(completeJobData);
      await getPublishedJobsByClient();
    } catch (e) {
      print('Error al crear job: $e');
      rethrow;
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentClientIdProvider);
  final db = ref.watch(firebaseFirestoreProvider);

  return JobNotifier(clientId, db);
});
