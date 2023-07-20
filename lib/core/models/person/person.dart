import '../../../static/shorten.dart';

class Person {
  String? uid;
  String? email;
  String? level;
  String? fcmToken;
  String? phoneNumber;
  String? photoURL;

  Person(
      {this.uid,
      this.email,
      this.level,
      this.fcmToken,
      this.phoneNumber,
      this.photoURL});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'level': level ?? "custo",
      'fcmToken': fcmToken,
      'phoneNumber': phoneNumber,
      "photoURL": photoURL ?? Shorten.noProfilePicUrl
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
        uid: map['uid'],
        email: map['email'],
        level: map['level'],
        fcmToken: map['fcmToken'],
        phoneNumber: map['phoneNumber'],
        photoURL: map["photoURL"]);
  }

  @override
  String toString() {
    return 'Person(uid: $uid, email: $email, level: $level, fcmToken: $fcmToken, phoneNumber: $phoneNumber, photoURL: $photoURL)';
  }
}
