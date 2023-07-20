import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../static/pods.dart';
import '../person/person.dart';
import 'message.dart';
import 'message_hub.dart';

class MessageVM implements MessageHub<Message, Person> {
  MessageVM(this._read);

  final Reader _read;

  @override
  Stream<List<Message>?> getMessages(Person custo, Person admin) {
    Stream<List<Message>?> messages = _read(hub).getMessages(custo, admin);
    return messages;
  }

  @override
  Future<bool> saveMessage(Message item, bool isAdmin) async {
    item.type = "text";
    bool bResult = await _read(hub).saveMessage(item, isAdmin);
    return bResult;
  }

  @override
  Future<void> deleteMessage(Message item, bool isAdmin) async {
    await _read(hub).deleteMessage(item, isAdmin);
  }

  @override
  Future<bool> savePicture(
      Message item, String folderName, XFile uploadFile) async {
    item.type = "picture";
    bool bResult = await _read(hub).savePicture(item, folderName, uploadFile);
    return bResult;
  }
}
