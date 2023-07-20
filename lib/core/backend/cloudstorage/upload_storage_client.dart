import 'package:image_picker/image_picker.dart';

abstract class UploadStorageClientBase {
  Future<String?> uploadPhoto(
      String userID, String folderName, XFile uploadFile);
}
