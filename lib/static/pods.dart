import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/backend/clouddb/firestore_video_call.dart';
import '../core/models/videocall/video_call_vm.dart';
import '../core/backend/notification_handler.dart';

import '../core/backend/auth/firebase_auth.dart';
import '../core/backend/clouddb/firestore_message_db.dart';
import '../core/backend/clouddb/firestore_person_db.dart';
import '../core/backend/cloudstorage/cloud_firestore_client.dart';
import '../core/hub.dart';
import '../core/models/message/message_vm.dart';
import '../core/models/person/person_vm.dart';

final firebaseInst = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final fireAuthClient =
    Provider<FirebaseClient>((ref) => FirebaseClient(ref.read));

final hub = Provider<Hub>((ref) => Hub(ref.read));

final personVMPod = StateNotifierProvider<PersonVM, PersonAuthState>(
    (ref) => PersonVM(PersonAuthState.needAuth, ref.read));

final firestoreInst = Provider<CollectionReference<Map<String, dynamic>>>(
    (ref) => FirebaseFirestore.instance.collection("users"));

final fcmInst =
    Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

final firePersonDB =
    Provider<FirestorePersonDB>((ref) => FirestorePersonDB(ref.read));

final fireMessageDB =
    Provider<FirestoreMessageDB>((ref) => FirestoreMessageDB(ref.read));

final messageVMPod = Provider<MessageVM>((ref) => MessageVM(ref.read));

final fireCloudInst =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final fireCloudClient =
    Provider<CloudFirestoreClient>((ref) => CloudFirestoreClient(ref.read));

final notification =
    Provider<NotificationHandler>((ref) => NotificationHandler());

final videoCallVMPod = Provider<VideoCallVM>((ref) => VideoCallVM(ref.read));

final fireFaceCoordinatePod =
    Provider<FirestoreVideoCallDB>((ref) => FirestoreVideoCallDB(ref.read));
