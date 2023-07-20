import 'package:image_picker/image_picker.dart';

abstract class PersonHub<T> {
  /* Future<T?> createAdmWEmailNPass(
      BuildContext context, String email, String password,String phoneNumber);
  Future<T?> createCustoWEmailNPass(
      BuildContext context, String email, String password,String phoneNumber); */
  Future<T?> signInWEmailNPass(String email, String password);
  T? getCurrentUser();
  Future<T?> createAdmWGoogle();
  Future<T?> signInWGoogle();
  Future<void> signOut();
  Future<bool> uploadProfilePhoto(
      String userID, String folderName, XFile uploadFile);
}
