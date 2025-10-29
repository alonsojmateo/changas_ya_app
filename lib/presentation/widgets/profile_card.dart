import 'package:changas_ya_app/Domain/Profile/Profile.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  static const int _maxTradesVisible = 2;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final tradesToShow = profile.trades?.take(_maxTradesVisible) ?? [];
    final hasMoreTrades = (profile.trades?.length ?? 0) > _maxTradesVisible;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.00),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto del perfil
            CircleAvatar(
              radius: 30,
              backgroundImage: profile.photoUrl.isNotEmpty
                  ? NetworkImage(profile.photoUrl) as ImageProvider<Object>?
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
                      if (profile.isProfessional && profile.rating != null)
                        Chip(
                          label: Text(
                            'Cal. ${profile.rating!.toStringAsFixed(1)}',
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
                  if (profile.isProfessional && profile.jobsCompleted != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        bottom: 2.0,
                      ), // Espacio superior
                      child: Text(
                        'Trabajos realizados: ${profile.jobsCompleted}',
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  Row(
                    // hago un map de los tradesToShow (cantidad configurable)
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
                            _showAllTradesModal(context, profile.trades!);
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
  }
}

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
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  // Generación simple de los chips
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
