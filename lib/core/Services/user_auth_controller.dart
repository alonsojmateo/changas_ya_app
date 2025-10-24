import 'package:firebase_auth/firebase_auth.dart';

class UserAuthController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Función asíncrona para el registro de usuario en Firebase.
  ///
  /// [email]: Correo electrónico del usuario.
  ///
  /// [password] Contraseña ingresada por el usuario.
  ///
  /// @returns: (bool, String)
  Future<void> registerUser(String email, String password) async {
    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Ya existe una cuenta con ese correo electrónico.');
      }

    } catch (e) {
      throw Exception("Error desconocido: $e");
    }
  }

}