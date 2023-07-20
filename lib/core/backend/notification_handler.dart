import 'package:http/http.dart' as http;

import '../models/message/message.dart';
import '../models/person/person.dart';
import '../models/videocall/video_call.dart';

class NotificationHandler {
  String url = "https://fcm.googleapis.com/fcm/send";

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization":
        "key=AAAAP-KF4jo:APA91bECgzDvXY8ICbPrYfkEAhi1cXK8jelwPHSAPi6RI6j0P4JjNdHgTNeAxxFM8ORJuA43HXDUvlpdFaPo6NYWe79o3KF1mbuhVDRdne2A935IDCUJSKk4y1kKZ5SXqe6T11Wb7Beb"
  };

  Future<void> pushNotification(Message message, Person person) async {
    String? content =
        message.type == "text" ? message.content : "Medya Gönderdi";

    String json =
        '{ "notification": { "title":"${person.email}", "body": "$content" },"to" : "${message.toFcmToken}","direct_boot_ok" : true }';

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: json);
    if (response.statusCode == 200) {
      print("işlem başarılı");
    }
  }

  Future<bool> pushVideoCallNotification(VideoCall videoCall) async {
    String content = "Görüntülü Konuşma İsteği";

    String json =
        '{ "notification": { "title":"${videoCall.from}", "body": "$content" }, "data": {"channelName":"${videoCall.channelName}", "toMe": "${videoCall.to}" }, "to": "${videoCall.toFcmToken}", "direct_boot_ok": true }';
    print(json);
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: json);
    if (response.statusCode == 200) {
      print("işlem başarılı");
      return true;
    }
    return false;
  }
}
