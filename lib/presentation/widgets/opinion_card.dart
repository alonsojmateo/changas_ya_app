import 'package:flutter/material.dart';

class OpinionCard extends StatelessWidget {
  final String nombreCliente;
  final String comentario;
  final int calificacion;

  const OpinionCard({
    super.key,
    required this.nombreCliente,
    required this.comentario,
    required this.calificacion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(nombreCliente),
        subtitle: Text(comentario),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => Icon(
              index < calificacion ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
