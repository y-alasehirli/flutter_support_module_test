import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/person/person.dart';
import '../../core/models/person/person_vm.dart';
import '../../static/pods.dart';
import '../widgets/pre_loading_indi.dart';
import 'home_page_landing.dart';
import 'login_page.dart';

class LandingStateful extends ConsumerStatefulWidget {
  const LandingStateful({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LandingStatefulState();
}

class _LandingStatefulState extends ConsumerState<LandingStateful> {
  late Person? _person;
  @override
  void initState() {
    setState(() {
      _person = ref.read(personVMPod.notifier).getCurrentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PersonAuthState _personAuthState = ref.watch(personVMPod);
    //PersonVM _personVM = ref.watch(personVMPod.notifier);

    switch (_personAuthState) {
      case PersonAuthState.needAuth:
        return const LoginPage();

      case PersonAuthState.authenticated:
        return HomePageLanding(_person!);

      case PersonAuthState.authenticating:
        return const PreLoadingIndi();
    }
  }
}
