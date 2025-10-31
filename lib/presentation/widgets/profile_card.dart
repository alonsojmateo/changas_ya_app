import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileCard extends ConsumerWidget {
  final String profileId;

  static const int _maxTradesVisible = 2;

  const ProfileCard({super.key, required this.profileId});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(professionalFutureProvider(profileId));

    return profile.when(
      loading: () => const Card(
        // Indicador de carga simple mientras se esperan los datos
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => Card(
        // Mostrar error
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error al cargar perfil: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (profile) {
        // Estado de datos: profile es de tipo profile?

        // Manejar el caso donde no se encuentra el usuario
        if (profile == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Perfil de profesional no disponible.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        // ⭐️ Lógica de datos (SAFE: profile ahora es de tipo profile) ⭐️

        final tradesToShow = profile.trades.take(_maxTradesVisible);
        final hasMoreTrades = (profile.trades.length) > _maxTradesVisible;

        // NOTA: Asumo que tu clase profile tiene los campos booleanos (isProfessional)
        // y numéricos (rating, completedJobs) necesarios.
        // He añadido un valor por defecto para 'completedJobs' si no existe en la clase profile.
        final completedJobs =
            35; // Aquí deberías usar profile.completedJobs si existe

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.00),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto del perfil
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                      ? NetworkImage(
                          profile.photoUrl!,
                        )
                      : null,
                  child: (profile.photoUrl == null || profile.photoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 30, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),

                // Informacion
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // NOTA: Asumo profile.isProfessional y profile.rating.
                          // Si no existen, usa valores seguros o implementa la lógica.
                          if (profile.isProfessional ?? false)
                            Chip(
                              label: Text(
                                // Usa el rating o un valor por defecto si es null
                                'Cal. ${(profile.rating ?? 0.0).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.green.shade500,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                        ],
                      ),
                      // Mostramos en caso de que sea profesional y tenga trabajos completados
                      if (profile.isProfessional ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            'Trabajos realizados: $completedJobs',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          ...tradesToShow.map(
                            (trade) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(
                                label: Text(
                                  trade,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                // Vista
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  250,
                                  244,
                                  234,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          if (hasMoreTrades)
                            GestureDetector(
                              onTap: () {
                                _showAllTradesModal(context, profile.trades);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  '...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// El resto de la función del modal no necesita cambios
void _showAllTradesModal(BuildContext context, List<String> allTrades) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Todos los Oficios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: allTrades
                      .map(
                        (trade) => Chip(
                          label: Text(trade),
                          backgroundColor: Colors.orange.shade100,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
