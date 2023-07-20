import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/videocall/video_call.dart';
import '../../static/pods.dart';
import '../pages/video_call_page.dart';

class MakeVideoCallButton extends ConsumerWidget {
  const MakeVideoCallButton({required this.videoCall, Key? key})
      : super(key: key);
  final VideoCall videoCall;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          bool bResult =
              await ref.read(videoCallVMPod).requestVideoCall(videoCall);
          if (bResult) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoCallPage(
                      /* channelName: videoCall.channelName! */),
                ));
          }
        },
        icon: const Icon(
          Icons.video_call_outlined,
          size: 30,
        ));
  }
}
