import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../static/pods.dart';
import 'upload_storage_client.dart';

class CloudFirestoreClient implements UploadStorageClientBase {
  CloudFirestoreClient(this._read);

  final Reader _read;

  @override
  Future<String?> uploadPhoto(
      String userID, String folderName, XFile uploadFile) async {
    Reference _storageRef = _read(fireCloudInst)
        .ref()
        .child(userID)
        .child(folderName)
        .child(uploadFile.name);

    UploadTask uploadTask = _storageRef.putFile(File(uploadFile.path));

    String _url = await (await uploadTask).ref.getDownloadURL();
    return _url;
  }
}
