import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../static/pods.dart';
import '../../models/person/person.dart';
import 'person_db_client.dart';

class FirestorePersonDB implements PersonDBClientBase<Person> {
  FirestorePersonDB(this._read);

  final Reader _read;

  @override
  Stream<List<Person>?> getAdminList() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = _read(firestoreInst)
        .where("level", isEqualTo: "admin")
        .orderBy("uid")
        .snapshots();

    return snapshots.map((list) =>
        list.docs.map((admin) => Person.fromMap(admin.data())).toList());
  }

  @override
  Stream<List<Person>?> getCustoList() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = _read(firestoreInst)
        .where("level", isEqualTo: "custo")
        .orderBy("uid")
        .snapshots();

    return snapshots.map((list) =>
        list.docs.map((custo) => Person.fromMap(custo.data())).toList());
  }

  @override
  Future<Person> readUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _read(firestoreInst).doc(uid).get();
    Person person = Person.fromMap(documentSnapshot.data()!);
    return person;
  }

  @override
  Future<bool> saveCusto(User user) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _read(firestoreInst).doc(user.uid).get();
    if (documentSnapshot.data() == null) {
      Person person = _userToPersonCnv(user);
      person.fcmToken = await _read(fcmInst).getToken();
      await _read(firestoreInst).doc(person.uid).set(person.toMap());
      return true;
    } else {
      String? newToken = await _read(fcmInst).getToken();
      if (documentSnapshot.data()!["fcmToken"] != newToken) {
        _read(firestoreInst).doc(user.uid).update({"fcmToken": newToken});
        return true;
      } else {
        return true;
      }
    }
  }

  @override
  Future<bool> saveAdmin(User user) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _read(firestoreInst).doc(user.uid).get();
    if (documentSnapshot.data() == null) {
      Person person = _userToPersonCnv(user);
      person.fcmToken = await _read(fcmInst).getToken();
      person.level = "admin";
      await _read(firestoreInst).doc(person.uid).set(person.toMap());
      return true;
    } else {
      String? newToken = await _read(fcmInst).getToken();
      if (documentSnapshot.data()!["fcmToken"] != newToken) {
        _read(firestoreInst).doc(user.uid).update({"fcmToken": newToken});
        return true;
      } else {
        return true;
      }
    }
  }

  Person _userToPersonCnv(User user) {
    return Person(
        email: user.email,
        uid: user.uid,
        level: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL);
  }

  @override
  Future<void> updateProfilePhotoURL(String userID, String photoURL) async {
    await _read(firestoreInst).doc(userID).update({"photoURL": photoURL});
  }
}
