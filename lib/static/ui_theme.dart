import 'package:flutter/material.dart';

class UITheme {
  //  AlertButtonNoTitleDialog Function
  static void alertButtonNoTitleDialog(
      BuildContext context, List<Widget> list) {
    showDialog(
        barrierColor: Colors.blue.withOpacity(0.2),
        context: context,
        builder: (context) => AlertDialog(
              actions: list,
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ));
  }

  //  AlertTextDialog Function
  static void alertTextDialog(
      BuildContext context, String text, List<Widget>? list) {
    showDialog(
        barrierColor: Colors.blueAccent.withOpacity(0.2),
        context: context,
        builder: (context) => AlertDialog(
            actions: list,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Text(text)));
  }
}
