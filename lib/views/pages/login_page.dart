import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_button.dart';
import 'sign_in_n_up_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.support_agent_rounded,
                size: 50,
                color: Colors.green,
              ),
              const Text(
                "Support Module Test",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 2,
                color: Colors.red,
                indent: 30,
                endIndent: 30,
              ),
              CustomImageButton(
                child: const Icon(Icons.login),
                title: "Giriş Yap",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SignInNUpPage(isRegistered: true),
                      ));
                },
              ),
              CustomImageButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SignInNUpPage(isRegistered: false),
                      ));
                },
                title: 'Kayıt Ol',
                child: const Icon(Icons.person_add_alt_1_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
