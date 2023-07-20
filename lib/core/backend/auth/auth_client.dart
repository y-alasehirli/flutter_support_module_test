import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthClientBase {
  User? getCurrentUser();
  Future<User?> createUserWEmailNPass(String email, String password);
  Future<User?> signInWEmailNPass(String email, String password);
  Future<User?> signInWGoogle();
  Future<void> signOut();
  Future<void> makeAdmLevel(User user);
  Future<User?> verifyPhoneNLinkUser(
      BuildContext context, User user, String phoneNumber);
  Future<void> updateProfilePhoto(String photoURL);
}
