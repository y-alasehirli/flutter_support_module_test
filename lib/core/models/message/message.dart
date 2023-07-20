import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? type;
  String? from;
  String? to;
  String? admin;
  String? content;
  Timestamp?
      contentTime; // Timestamp girip bu şekilde modelleme yapılması gerekiyor. Aksi taktirde DateTime çevirildiğinde Stream Timestamp - Datetime çevirimine girip saniyelik Loading aşamasına düşüyor.
  String? messageID;
  String? toFcmToken;

  Message(
      {this.type,
      this.from,
      this.to,
      this.admin,
      this.content,
      this.contentTime,
      this.messageID,
      this.toFcmToken});

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      'from': from,
      'to': to,
      'admin': admin,
      'content': content,
      'contentTime': contentTime ?? FieldValue.serverTimestamp(),
      'messageID': messageID,
      "toFcmToken": toFcmToken
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        type: map["type"],
        from: map['from'],
        to: map['to'],
        admin: map['admin'],
        content: map['content'],
        contentTime: map['contentTime'],
        messageID: map['messageID'],
        toFcmToken: map["toFcmToken"]);
  }
}
