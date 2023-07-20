import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtclocalview;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtcremoteview;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/models/faceposition/face_position.dart';

import '../../static/identity.dart';
import '../../static/pods.dart';
import '../widgets/face_mask.dart';
import '../widgets/face_mask_w_coordinate.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  int? _remoteUid;
  late RtcEngine _rtcEngine;
  Map<Permission, PermissionStatus>? perMap;
  FacePositionInfo? detectedFace;
  FaceMaskWidget? faceMaskWidget;

  Future<void> initForAgoraClient() async {
    perMap = await [Permission.camera, Permission.microphone].request();
    _rtcEngine = await RtcEngine.create(Identity.agoraAppID);
    await _rtcEngine.enableVideo();
    //await _rtcEngine.enableFaceDetection(true);

    _rtcEngine.setEventHandler(RtcEngineEventHandler(
      /*  facePositionChanged: (imageWidth, imageHeight, faces) {
        for (FacePositionInfo face in faces) {
          bool isWrite = ref.watch(personVMPod.notifier).person!.email ==
                  "musteri1@deneme.com"
              ? false
              : true;

          ref.read(hub).postFaceDetection(face, isWrite).then((value) {
            detectedFace = face;
            setState(() {
              faceMaskWidget = FaceMaskWidget(facePositionInfo: detectedFace!);
            });
          });

          print(
              "distance: ${face.distance} ,height: ${face.height} ,width: ${face.width} ,x: ${face.x} ,y: ${face.y}");
        }
        return print("facepositon : $imageWidth, $imageHeight, }");
      }, */
      joinChannelSuccess: (channel, uid, elapsed) {
        print("local user $uid joined");
      },
      userJoined: (uid, elapsed) {
        print("remote user $uid joined");
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (uid, reason) async {
        print("remote user $uid left channel");
        setState(() {
          _remoteUid = null;
        });
      },
    ));

    await _rtcEngine.joinChannel(
        Identity.agoraTempToken, Identity.tempChannelName, null, 0);
  }

  @override
  void initState() {
    super.initState();
    initForAgoraClient();
  }

  @override
  void dispose() {
    _rtcEngine.destroy().then((value) {
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: Stack(
        children: [
          Center(
            child: _remoteScreen(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 120,
                width: 100,
                child: Center(
                  child: _localScreen(),
                ),
              ),
            ),
          ),
          /*  faceMaskWidget == null ? const SizedBox() : faceMaskWidget!,
          Stack(
            children: [
              StreamBuilder(
                stream: ref.watch(fireFaceCoordinatePod).getRemoteFaceInfo(),
                builder: (context, AsyncSnapshot<FaceCoordinate> snapshot) {
                  if (snapshot.hasData) {
                    FaceMaskWidgetWCoordinate faceMaskWidgetWCoordinate =
                        FaceMaskWidgetWCoordinate(
                            faceCoordinate: snapshot.data!);
                    return faceMaskWidgetWCoordinate;
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
            alignment: Alignment.center,
          ) */
        ],
      ),
    ));
  }

  _remoteScreen() {
    if (_remoteUid != null) {
      return rtcremoteview.SurfaceView(
        uid: _remoteUid!,
      );
    } else {
      return const Text(
        "Kullanıcının katılımı bekleniyor",
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _localScreen() {
    if (perMap != null) {
      return rtclocalview.SurfaceView();
    } else {
      return Container();
    }
  }
}
