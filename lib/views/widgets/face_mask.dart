import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class FaceMaskWidget extends StatefulWidget {
  const FaceMaskWidget({required this.facePositionInfo, Key? key})
      : super(key: key);
  final FacePositionInfo facePositionInfo;
  @override
  State<FaceMaskWidget> createState() => _FaceMaskWidgetState();
}

class _FaceMaskWidgetState extends State<FaceMaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: widget.facePositionInfo.height.toDouble(),
        width: widget.facePositionInfo.width.toDouble(),
        top: widget.facePositionInfo.y.toDouble(),
        left: widget.facePositionInfo.x.toDouble(),
        child: Image.asset(
          "assets/images/tomato.png",
        ));
  }
}
