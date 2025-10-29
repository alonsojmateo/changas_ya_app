// lib/presentation/screens/test_screen.dart

import 'package:changas_ya_app/Domain/Profile/Profile.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';

class TestScreen extends StatelessWidget {
  static const String name = 'test_screen';
  
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 Datos de prueba (mocks) para tus widgets
    final Profile professionalProfile = Profile(
      id: 'p1', 
      name: 'Juan Pérez (Prof.)', 
      photoUrl: 'https://picsum.photos/id/237/200/300', 
      type: 'professional',
      rating: 4.5,
      jobsCompleted: 35,
      trades: const ['Plomería', 'Electricista', 'Albañilería', 'Pintura', 'Jardinería'],
      totalBudget: 15000.75, // Para probar la reutilización con presupuesto
    );

    final Profile clientProfile = Profile(
      id: 'c1', 
      name: 'María García (Cliente)', 
      photoUrl: 'https://picsum.photos/id/1011/200/300', 
      type: 'client',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Widgets de Prueba'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 1. PRUEBA DEL WIDGET PROFILECARD (Profesional con todos los datos) ===
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('1. ProfileCard (Profesional Completo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ProfileCard(profile: professionalProfile),

            // === 2. PRUEBA DEL WIDGET PROFILECARD (Cliente Básico) ===
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('2. ProfileCard (Cliente Básico)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ProfileCard(profile: clientProfile),

            // === 3. PRUEBA DEL WIDGET PROFILECARD (Vista de Presupuesto) ===
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('3. ProfileCard (Profesional + Presupuesto)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ProfileCard(
              profile: professionalProfile.copyWith(
                trades: ['Plomeria'],
                rating: null, // Omitimos rating en esta vista si es necesario
              ),
            ),
            
            // 📝 Aquí agregarás otros widgets que desarrolles (ej: JobCard, CustomButton)
          ],
        ),
      ),
    );
  }
}