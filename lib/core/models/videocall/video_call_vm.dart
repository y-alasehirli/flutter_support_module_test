import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'video_call_hub.dart';
import '../../../static/pods.dart';

import 'video_call.dart';

class VideoCallVM implements VideoCallHub<VideoCall> {
  VideoCallVM(this._read);
  final Reader _read;

  @override
  Future<bool> requestVideoCall(VideoCall item) async {
    return await _read(hub).requestVideoCall(item);
  }
}
