import 'package:firebase_auth/firebase_auth.dart';

abstract class PersonDBClientBase<T> {
  Future<T> readUser(String uid);
  Future<bool> saveCusto(User user);
  Future<bool> saveAdmin(User user);
  Stream<List<T>?> getCustoList();
  Stream<List<T>?> getAdminList();
  Future<void> updateProfilePhotoURL(String userID, String photoURL);
}
