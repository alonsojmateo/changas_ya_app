import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/core/data/job_datasource.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentClientIdProvider = StateProvider<String>((ref) => 'test-client-mock');

class JobNotifier extends StateNotifier<List<Job>> {
  final String _currentClientId;

  JobNotifier(this._currentClientId) : super([]);

  Future<void> getPublishedJobsByClient() async {
    // Debe retornar los trabajos publicados por cliente activo
    try {
      await Future.delayed(const Duration(milliseconds: 700)); 
      
      // 2. Obtiene los 3 trabajos fijos, pasando el ID del cliente
      final jobs = getMockJobsByClient(_currentClientId);
      
      // 3. Actualiza el estado, notificando a la UI
      state = jobs;
      
    } catch (e) {
      print('Error al cargar trabajos publicados: $e');
      // En caso de fallo, el estado queda vacío
      state = []; 
    }
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, List<Job>>((ref) {
  final clientId = ref.watch(currentClientIdProvider); 
  
  return JobNotifier(clientId);
});