import 'package:image_picker/image_picker.dart';

abstract class MessageHub<T, O> {
  Future<bool> saveMessage(T item, bool isAdmin);
  Stream<List<T>?> getMessages(O custo, O admin);
  Future<void> deleteMessage(T item, bool isAdmin);
  Future<bool> savePicture(T item, String folderName, XFile uploadFile);
}
