import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final String title;
  final Widget child;

  final VoidCallback onPressed;

  const CustomImageButton({
    Key? key,
    required this.title,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: child,
              ),
              Text(title),
              const Opacity(opacity: 0, child: CircleAvatar())
            ],
          ),
        ),
      ),
    );
  }
}
