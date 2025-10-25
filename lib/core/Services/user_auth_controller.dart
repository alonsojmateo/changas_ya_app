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

  Future<void> userLogIn(String email, String password) async{
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
        );

        //TODO: Add the user state to riverpod.
    } on FirebaseAuthException catch(e) {
        String exceptionMessage = '';

        if (e.code == 'invalid-email' || e.code == 'wrong-password' || e.code == 'invalid-credential'){
          exceptionMessage = 'Credenciales ingresadas, invalidas.';
        } else if (e.code == 'user-disabled') {
          exceptionMessage = 'El usuario se encuentra desahabilitado.';
        } else if (e.code == 'user-not-found') {
          exceptionMessage = 'Usuario no registrado.';
        }
        throw Exception(exceptionMessage);
    } catch (e) {
      String errorMessage = e.toString();

      throw Exception("Error desconocido: $errorMessage");
    }
  }

  Future<void> userLogOut() async {
    try{
      await _auth.signOut();
    } catch (e){
      throw Exception('Ocurrió un error al cerrar sesión.');
    }
    
  }
}