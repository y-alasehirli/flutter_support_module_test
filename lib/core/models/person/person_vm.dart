import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../static/pods.dart';
import 'person.dart';
import 'person_hub.dart';

enum PersonAuthState { authenticated, authenticating, needAuth }

class PersonVM extends StateNotifier<PersonAuthState>
    implements PersonHub<Person> {
  PersonVM(PersonAuthState state, this._read)
      : super(PersonAuthState.needAuth) {
    getCurrentUser();
  }

  final Reader _read;
  Person? _person;

  Person? get person => _person;
//Convert metodları "/static" altında "convert.dart" sayfası altında toplanması lazım
  Person _userToPersonCnv(User user) {
    return Person(
        email: user.email,
        uid: user.uid,
        level: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL);
  }

  //@override
  Future<Person?> createAdmWEmailNPass(BuildContext context, String email,
      String password, String phoneNumber) async {
    state = PersonAuthState.authenticating;
    try {
      User? user = await _read(hub).createAdmWEmailNPass(
        /* context, */ email,
        password, /* phoneNumber */
      );
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);
        userToPersonCnv.level = "admin";
        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  // @override
  Future<Person?> createCustoWEmailNPass(BuildContext context, String email,
      String password, String phoneNumber) async {
    state = PersonAuthState.authenticating;
    try {
      User? user = await _read(hub).createCustoWEmailNPass(
        /* context, */ email,
        password, /* phoneNumber */
      );
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);

        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  @override
  Person? getCurrentUser() {
    state = PersonAuthState.authenticating;
    try {
      User? user = _read(hub).getCurrentUser();
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);
        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  @override
  Future<Person?> createAdmWGoogle() async {
    state = PersonAuthState.authenticating;
    try {
      User? user = await _read(hub).createAdmWGoogle();
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);
        userToPersonCnv.level = "admin";
        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  @override
  Future<Person?> signInWGoogle() async {
    state = PersonAuthState.authenticating;
    try {
      User? user = await _read(hub).signInWGoogle();
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);
        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  @override
  Future<Person?> signInWEmailNPass(String email, String password) async {
    state = PersonAuthState.authenticating;
    try {
      User? user = await _read(hub).signInWEmailNPass(email, password);
      if (user != null) {
        state = PersonAuthState.authenticated;
        Person userToPersonCnv = _userToPersonCnv(user);
        _person = userToPersonCnv;
      } else {
        _person = null;
        state = PersonAuthState.needAuth;
      }
    } finally {}
  }

  @override
  Future<void> signOut() async {
    state = PersonAuthState.authenticating;
    try {
      await _read(hub).signOut();
    } finally {
      _person = null;
      state = PersonAuthState.needAuth;
    }
  }

  @override
  Future<bool> uploadProfilePhoto(
      String userID, String folderName, XFile uploadFile) async {
    try {
      return await _read(hub)
          .uploadProfilePhoto(userID, folderName, uploadFile);
    } catch (e) {
      return false;
    }
  }
}
