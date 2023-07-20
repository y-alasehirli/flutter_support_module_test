import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../static/pods.dart';
import '../pages/landing_page.dart';

class CustomLogOutButton extends ConsumerWidget {
  const CustomLogOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () {
          ref.read(personVMPod.notifier).signOut();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(),
              ),
              (route) => false);
        },
        icon: const Icon(Icons.logout));
  }
}
