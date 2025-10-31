import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'usuarios';

  ProfileRepository(this._db);

  Future<Profile?> fetchProfileById(String id) async {
    try {
      final usersCollection = _db.collection(_collectionName).withConverter<Profile>(
        fromFirestore: (snapshot, _) => Profile.fromFirestore(snapshot.data()!, snapshot.id),
        toFirestore: (Profile profile, _) => profile.toFirestore(),
      );

      final docSnapshot = await usersCollection.doc(id).get();
      return docSnapshot.data();
      
    } catch (e) {
      print('Error en UserRepository.fetchUserById: $e');
      throw Exception('Fallo al obtener el usuario.'); 
    }
  }
}