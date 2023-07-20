class VideoCall {
  // Person? admin;
  // Person? custo;
  // bool? connected;
  String? toFcmToken;
  String? from;
  String? to;
  String? channelName;

  VideoCall({this.toFcmToken, this.from, this.to, this.channelName});

  Map<String, dynamic> toMap() {
    return {
      'toFcmToken': toFcmToken,
      'from': from,
      'to': to,
      'channelName': channelName,
    };
  }

  factory VideoCall.fromMap(Map<String, dynamic> map) {
    return VideoCall(
      toFcmToken: map['toFcmToken'],
      from: map['from'],
      to: map['to'],
      channelName: map['channelName'],
    );
  }
}
