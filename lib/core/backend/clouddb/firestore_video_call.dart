import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/faceposition/face_position.dart';
import '../../../static/pods.dart';

class FirestoreVideoCallDB {
  FirestoreVideoCallDB(this._read);
  final Reader _read;

  Future<void> postFaceDetection(FacePositionInfo face) async {
    Map<String, dynamic> facePosition = {
      "height": face.height,
      "width": face.width,
      "x": face.x,
      "y": face.y
    };
    await _read(firestoreInst).doc("deneme").set(facePosition);
  }

  Stream<FaceCoordinate> getRemoteFaceInfo() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        _read(firestoreInst).doc("deneme").snapshots();
    return snapshots.map((event) => FaceCoordinate.fromMap(event.data()!));
  }
}
