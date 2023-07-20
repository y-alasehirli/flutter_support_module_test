import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../static/pods.dart';
import '../../models/message/message.dart';
import '../../models/person/person.dart';
import 'message_db_client.dart';

class FirestoreMessageDB implements MessageDBClient<Message, Person> {
  FirestoreMessageDB(this._read);

  final Reader _read;

  @override
  Future<bool> saveMessage(Message item, bool isAdmin) async {
    String mid = _read(firestoreInst)
        .doc(item.from)
        .collection("messages")
        .doc(item.to)
        .collection("conversation")
        .doc()
        .id;
    item.messageID = mid;
    await _read(firestoreInst)
        .doc(!isAdmin ? item.from : item.to) //custo
        .collection("messages")
        .doc(!isAdmin ? item.to : item.from) //admin
        .collection("conversation")
        .doc(mid)
        .set(item.toMap());

    return true;
  }

  @override
  Future<void> deleteMessage(Message item, bool isAdmin) async {
    await _read(firestoreInst)
        .doc(!isAdmin ? item.from : item.to) //custo
        .collection("messages")
        .doc(!isAdmin ? item.to : item.from) //admin
        .collection("conversation")
        .doc(item.messageID)
        .delete();
  }

  @override
  Stream<List<Message>?> getMessages(Person custo, Person admin) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = _read(firestoreInst)
        .doc(custo.uid)
        .collection("messages")
        .doc(admin.uid)
        .collection("conversation")
        .where("admin", isEqualTo: admin.uid)
        .orderBy("contentTime", descending: true)
        .snapshots();

    return snapshots.map((list) =>
        list.docs.map((message) => Message.fromMap(message.data())).toList());
  }
}
