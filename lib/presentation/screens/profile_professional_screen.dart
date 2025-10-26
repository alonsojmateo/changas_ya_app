import 'package:flutter/material.dart';
import '../widgets/opinion_card.dart';

// Pantalla de perfil profesional
class ProfileProfesionalScreen extends StatelessWidget {

  const ProfileProfesionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil Profesional')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/default_profile.jpg',
                ),
              ),
            ),
            const SizedBox(height: 16),

// SON DATOS HARDOCODEADOS PARA TESTEAR LA PANTALLA, REEMPLAZAR LUEGO CON DATOS REALES, CON LA MISMA LOGICA QUE JOBS. USANDO PROVIDER, PARA USAR MOCK.
            // Nombre completo
            const Center(
              child: Text(
                'Juan Pérez',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // Descripción profesional
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Electricista matriculado con más de 10 años de experiencia en obras residenciales y comerciales.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            // Oficios
            const Text(
              'Oficios:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Electricista')),
                Chip(label: Text('Gasista')),
              ],
            ),

            const SizedBox(height: 20),

            // Cantidad de trabajos realizados
            const Text(
              'Trabajos realizados: 34',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Contacto
            const Text(
              'Contacto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('📞 +54 11 5678-9123'),
            const Text('📧 juanperez@gmail.com'),

            const SizedBox(height: 20),

            // Opiniones (hardcodeadas por ahora, revisar)
            const Text(
              'Opiniones recientes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            OpinionCard(
              nombreCliente: 'María López',
              comentario: 'Excelente trabajo, muy prolijo y puntual.',
              calificacion: 5,
            ),
            OpinionCard(
              nombreCliente: 'Carlos Fernández',
              comentario: 'Buen trabajo, aunque demoró un poco.',
              calificacion: 4,
            ),
          ],
        ),
      ),
    );
  }
}


/*

para testear mas rapido:

Crear la siguiente clase en la carpeta screen:

import 'package:flutter/material.dart';
import 'screens/profile_profesional_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: ProfileProfesionalScreen(),
  ));
}


*/