import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import '../../core/models/faceposition/face_position.dart';

class FaceMaskWidgetWCoordinate extends StatefulWidget {
  const FaceMaskWidgetWCoordinate({required this.faceCoordinate, Key? key})
      : super(key: key);
  final FaceCoordinate faceCoordinate;
  @override
  State<FaceMaskWidgetWCoordinate> createState() =>
      _FaceMaskWidgetWCoordinateState();
}

class _FaceMaskWidgetWCoordinateState extends State<FaceMaskWidgetWCoordinate> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: widget.faceCoordinate.height!.toDouble(),
        width: widget.faceCoordinate.width!.toDouble(),
        top: widget.faceCoordinate.y!.toDouble(),
        left: widget.faceCoordinate.x!.toDouble(),
        child: Image.asset(
          "assets/images/potato.png",
        ));
  }
}
