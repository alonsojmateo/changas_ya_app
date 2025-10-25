import 'package:flutter/material.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';
import 'package:changas_ya_app/presentation/components/banner_widget.dart';

class PerfilScreen extends StatelessWidget {
  static const String screenName = 'perfilScreen';

  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String bannerImage = 'lib/images/profile_banner.png'; //CAMBIAR
    final String bannerTitle = 'Mi Perfil';
    final textStyle = Theme.of(context).textTheme;
    final TextStyle titleStyle = TextStyle(
      fontSize: textStyle.titleLarge?.fontSize ?? 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.2,
    );

    // Datos simulados del usuario (más adelante se obtendrán desde backend)
    final String userName = 'Juan Pérez';
    final String userEmail = 'juanperez@gmail.com';
    final String userAddress = 'Av. Siempre Viva 742';
    final String userPhone = '+54 9 11 1234-5678';
    final double promedio = 4.5;

    final List<Map<String, dynamic>> opiniones = [
      {'comentario': 'Excelente servicio', 'calificacion': 5},
      {'comentario': 'Muy cumplidor', 'calificacion': 4},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Bannerwidget(
              imageAsset: bannerImage,
              titleStyle: titleStyle,
              titleToShow: bannerTitle,
            ),
            const SizedBox(height: 20),

            // Foto de perfil
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('lib/images/profile_placeholder.png'),
            ),
            const SizedBox(height: 10),

            // Datos personales
            Text(userName, style: textStyle.titleLarge),
            const SizedBox(height: 5),
            Text(userEmail),
            Text(userAddress),
            Text(userPhone),
            const SizedBox(height: 20),

            // Calificación promedio
            Text(
              'Calificación promedio: $promedio ⭐',
              style: textStyle.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30, thickness: 1),

            // Opiniones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Opiniones:', style: textStyle.titleMedium),
                  const SizedBox(height: 10),
                  ...opiniones.map((opinion) => Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(opinion['comentario']),
                          trailing:
                              Text('${opinion['calificacion']} ⭐', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/*
Para testear que esto funciona (al no tener la parte de trabajo hecha todavia y usar la navegacion actual)

Se puede crear una clase test(en la misma carpeta screens) asi:

import 'package:flutter/material.dart';
import 'package:changas_ya_app/presentation/screens/profile_screen.dart';

void main() {
  runApp(const ProfileTestApp());
}

class ProfileTestApp extends StatelessWidget {
  const ProfileTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test PerfilScreen',
      debugShowCheckedModeBanner: false,
      home: const PerfilScreen(),
    );
  }
}

y luego en la terminal hacer: "flutter run -t lib/presentation/screens/test_profile_screen.dart "
para que abra esa pantalla directamente en vez de la home screen.

*/