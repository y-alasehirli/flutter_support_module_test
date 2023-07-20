import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'models/videocall/video_call.dart';
import 'models/videocall/video_call_hub.dart';

import '../static/pods.dart';
import 'models/message/message.dart';
import 'models/message/message_hub.dart';
import 'models/person/person.dart';
import 'models/person/person_hub.dart';

class Hub
    implements
        PersonHub<User>,
        MessageHub<Message, Person>,
        VideoCallHub<VideoCall> {
  Hub(this._read);

  final Reader _read;
  //@override
  Future<User?> createAdmWEmailNPass(String email, String password) async {
    User? user =
        await _read(fireAuthClient).createUserWEmailNPass(email, password);
    if (user != null) {
      await _read(fireAuthClient).makeAdmLevel(user);
      /* User? userWPhone = await _read(fireAuthClient)
          .verifyPhoneNLinkUser(context, user, phoneNumber);
      if (userWPhone != null) {
        bool bResult = await _read(firePersonDB).saveAdmin(userWPhone);
        if (bResult) return userWPhone; */
      return user;
    } else {
      return null;
    }
  }

  //@override
  Future<User?> createCustoWEmailNPass(String email, String password) async {
    User? user =
        await _read(fireAuthClient).createUserWEmailNPass(email, password);
    if (user != null) {
      /* User? userWPhone = await _read(fireAuthClient)
          .verifyPhoneNLinkUser(context, user, phoneNumber);
      if (userWPhone != null) {
        bool bResult = await _read(firePersonDB).saveCusto(user);
        if (bResult) return user;
      } */
      return user;
    } else {
      return null;
    }
  }

  @override
  User? getCurrentUser() {
    User? currentUser = _read(fireAuthClient).getCurrentUser();
    if (currentUser != null) {
      return currentUser;
    } else {
      return null;
    }
  }

  @override
  Future<User?> signInWGoogle() async {
    User? user = await _read(fireAuthClient).signInWGoogle();
    if (user != null) {
      bool bResult = await _read(firePersonDB).saveCusto(user);
      if (bResult) return user;
    } else {
      return null;
    }
  }

  @override
  Future<User?> signInWEmailNPass(String email, String password) async {
    User? user = await _read(fireAuthClient).signInWEmailNPass(email, password);
    if (user != null) {
      bool bResult = await _read(firePersonDB).saveCusto(user);
      if (bResult) return user;
    } else {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _read(fireAuthClient).signOut();
  }

  @override
  Future<User?> createAdmWGoogle() async {
    User? user = await _read(fireAuthClient).signInWGoogle();
    if (user != null) {
      await _read(fireAuthClient).makeAdmLevel(user);
      /*  bool bResult = await _read(firePersonDB).saveAdmin(user);
      if (bResult) return user; */
      return user;
    } else {
      return null;
    }
  }

  @override
  Stream<List<Message>?> getMessages(Person custo, Person admin) {
    Stream<List<Message>?> messages =
        _read(fireMessageDB).getMessages(custo, admin);
    return messages;
  }

  @override
  Future<bool> saveMessage(Message item, bool isAdmin) async {
    bool bResult = await _read(fireMessageDB).saveMessage(item, isAdmin);

    //TODO:FCM metodu eklenecek. Buraya eklenmesi lazımdı. Ama UI'nin içerisine yerleştirildi bu projede.

    return bResult;
  }

  @override
  Future<bool> uploadProfilePhoto(
      String userID, String folderName, XFile uploadFile) async {
    String? photoURL = await _read(fireCloudClient)
        .uploadPhoto(userID, folderName, uploadFile);
    if (photoURL != null) {
      await _read(firePersonDB).updateProfilePhotoURL(userID, photoURL);
      await _read(fireAuthClient).updateProfilePhoto(photoURL);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> deleteMessage(Message item, bool isAdmin) async {
    await _read(fireMessageDB).deleteMessage(item, isAdmin);
  }

  @override
  Future<bool> savePicture(
      Message item, String folderName, XFile uploadFile) async {
    String? photoURL = await _read(fireCloudClient)
        .uploadPhoto(item.from!, folderName, uploadFile);
    if (photoURL != null) {
      bool isAdmin;
      isAdmin = item.from == item.admin ? true : false;
      item.content = photoURL;
      return await _read(fireMessageDB).saveMessage(item, isAdmin);
    } else {
      return false;
    }
  }

  @override
  Future<bool> requestVideoCall(VideoCall item) async {
    return await _read(notification).pushVideoCallNotification(item);
  }

  Future<void> postFaceDetection(FacePositionInfo face, bool isWrite) async {
    if (isWrite) {
      await _read(fireFaceCoordinatePod).postFaceDetection(face);
    }
  }
}
