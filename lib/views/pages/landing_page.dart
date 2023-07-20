import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/person/person_vm.dart';
import '../../static/pods.dart';
import '../widgets/pre_loading_indi.dart';
import 'home_page_landing.dart';
import 'login_page.dart';
import 'phone_verification_page.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PersonAuthState _personAuthState = ref.watch(personVMPod);
    PersonVM _personVM = ref.watch(personVMPod.notifier);
    User? _user = ref.watch(fireAuthClient).getCurrentUser();

    switch (_personAuthState) {
      case PersonAuthState.needAuth:
        return const LoginPage();

      case PersonAuthState.authenticated:
        if (_personVM.person!.phoneNumber == null) {
          return PhoneVerificationPage(_user!);
        } else {
          return HomePageLanding(_personVM.person!);
        }

      case PersonAuthState.authenticating:
        return const PreLoadingIndi();
    }
  }
}
