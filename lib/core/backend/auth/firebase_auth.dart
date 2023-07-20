import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../static/pods.dart';
import '../../../views/pages/home_page_landing.dart';
import '../../models/person/person.dart';
import 'auth_client.dart';

class FirebaseClient implements AuthClientBase {
  final Reader _read;
  /*  User? _user;

  User? get user => _user; */

  FirebaseClient(this._read);

  Person _userToPersonCnv(User user) {
    return Person(email: user.email, uid: user.uid, level: user.displayName, phoneNumber: user.phoneNumber, photoURL: user.photoURL);
  }

  @override
  Future<User?> createUserWEmailNPass(String email, String password) async {
    UserCredential userCredential = await _read(firebaseInst).createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      return userCredential.user;
    } else {
      return null;
    }
  }

  @override
  User? getCurrentUser() {
    User? currentUser = _read(firebaseInst).currentUser;
    if (currentUser != null) {
      return currentUser;
    } else {
      return null;
    }
  }

  @override
  Future<User?> signInWEmailNPass(String email, String password) async {
    UserCredential userCredential = await _read(firebaseInst).signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      return userCredential.user;
    } else {
      return null;
    }
  }

  @override
  Future<User?> signInWGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      OAuthCredential credential =
          GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
      UserCredential userCredential = await _read(firebaseInst).signInWithCredential(credential);
      if (userCredential.user != null) {
        return userCredential.user;
      }
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _read(firebaseInst).signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  Future<void> makeAdmLevel(User user) async {
    await user.updateDisplayName("admin");
  }

  @override
  Future<User?> verifyPhoneNLinkUser(BuildContext context, User user, String phoneNumber) async {
    User? _uniUser;
    await _read(firebaseInst).verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) async {
        UserCredential userCredential = await user.linkWithCredential(phoneAuthCredential);
        if (userCredential.user != null) {
          _uniUser = userCredential.user;
          Person person = _userToPersonCnv(_uniUser!);
          if (person.level == "admin") {
            await _read(firePersonDB).saveAdmin(_uniUser!);
          } else {
            await _read(firePersonDB).saveCusto(_uniUser!);
          }

          print("verification complete:" + _uniUser.toString());
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            return HomePageLanding(person);
          }), (route) => false);
        }
      },
      verificationFailed: (error) {
        print(error.code);
      },
      codeSent: (verificationId, forceResendingToken) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            TextEditingController _controller = TextEditingController();
            String smsCode;
            Size _size = MediaQuery.of(context).size;
            return AlertDialog(
                title: const Text("SMS kodu giriniz"),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularCountDownTimer(
                        width: _size.width * 0.1,
                        height: _size.width * 0.1,
                        duration: 60,
                        fillColor: Colors.blue,
                        ringColor: Colors.red,
                        isReverse: true,
                        isReverseAnimation: true,
                      ),
                      const Divider(),
                      TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: _controller,
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                      child: const Text("Tamam"),
                      onPressed: () async {
                        if (_controller.text.trim().isNotEmpty) {
                          smsCode = _controller.text.trim();
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                          UserCredential userCredential = await user.linkWithCredential(credential);
                          if (userCredential.user != null) {
                            _uniUser = userCredential.user;
                            Person person = _userToPersonCnv(_uniUser!);
                            if (person.level == "admin") {
                              await _read(firePersonDB).saveAdmin(_uniUser!);
                            } else {
                              await _read(firePersonDB).saveCusto(_uniUser!);
                            }

                            print("codeSent complete:" + _uniUser.toString());
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                              _controller.dispose();
                              return HomePageLanding(person);
                            }), (route) => false);
                          } /*  else {
                            print("codeSent uncomplete:" + _uniUser.toString());
                            _uniUser = null;
                          }
                        } else {
                          print("codeSent nullcomplete:" + _uniUser.toString());

                          null; */
                        }
                      })
                ]);
          },
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print(verificationId);
      },
    );
    print("------------\nuniUser: " + _uniUser.toString());

    if (_uniUser != null) {
      return _uniUser;
    }
  }

  @override
  Future<void> updateProfilePhoto(String photoURL) async {
    await _read(firebaseInst).currentUser?.updatePhotoURL(photoURL);
  }
}
