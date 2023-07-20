import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../static/pods.dart';
import '../../static/shorten.dart';
import '../widgets/custom_button.dart';
import 'phone_verification_page.dart';

class SignInNUpPage extends ConsumerStatefulWidget {
  const SignInNUpPage({required this.isRegistered, Key? key}) : super(key: key);
  final bool isRegistered;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInNUpPageState();
}

class _SignInNUpPageState extends ConsumerState<SignInNUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? _email, _password;
  late String _buttonText;
  bool _beAdmin = false;

  _setButtonText() {
    if (widget.isRegistered) {
      _buttonText = "Giriş Yap";
    } else {
      _buttonText = "Kayıt Ol";
    }
  }

  @override
  void initState() {
    super.initState();
    _setButtonText();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Material(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (!EmailValidator.validate(value!, true)) {
                      return "Geçerli bir email giriniz";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) {
                    _email = newValue;
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      suffixIcon: const Icon(Icons.email_outlined),
                      labelText: "Eposta",
                      filled: true,
                      fillColor: Colors.lightBlue.withOpacity(0.1)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.length < 6) {
                      return "En az 6 karakter giriniz";
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (newValue) {
                    _password = newValue;
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      suffixIcon: const Icon(Icons.password),
                      labelText: "Şifre",
                      filled: true,
                      fillColor: Colors.lightBlue.withOpacity(0.1)),
                ),
                const SizedBox(
                  height: 10,
                ),
                !widget.isRegistered
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.support_agent_rounded),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("Support"),
                          Checkbox(
                            value: _beAdmin,
                            onChanged: (value) {
                              setState(() {
                                _beAdmin = value!;
                              });
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
                CustomImageButton(
                  title: _buttonText,
                  child: widget.isRegistered
                      ? const Icon(Icons.login)
                      : const Icon(Icons.person_add_alt_1_outlined),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        if (widget.isRegistered) {
                          await ref
                              .read(personVMPod.notifier)
                              .signInWEmailNPass(_email!, _password!);
                          Navigator.pop(context);
                        } else if (!widget.isRegistered && !_beAdmin) {
                          User? user = await ref
                              .read(hub)
                              .createCustoWEmailNPass(_email!, _password!);
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PhoneVerificationPage(user),
                                ));
                          }
                        } else if (!widget.isRegistered && _beAdmin) {
                          User? user = await ref
                              .read(hub)
                              .createAdmWEmailNPass(_email!, _password!);
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PhoneVerificationPage(user),
                                ));
                          }
                        }
                      } on Exception catch (e) {
                        _email = null;
                        _password = null;
                        showDialog(
                          context: context,
                          builder: (context) => Text("Hata : " + e.toString()),
                        );
                      }
                    }
                  },
                ),
                const Divider(),
                const Text("veya"),
                CustomImageButton(
                  title: "Google ile " + _buttonText,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.network(
                      Shorten.googleLogoUrl,
                      scale: 70,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      if (widget.isRegistered) {
                        await ref.read(personVMPod.notifier).signInWGoogle();
                      } else if (!widget.isRegistered && !_beAdmin) {
                        User? user = await ref.read(hub).signInWGoogle();
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PhoneVerificationPage(user),
                              ));
                        }
                      } else if (!widget.isRegistered && _beAdmin) {
                        User? user = await ref.read(hub).createAdmWGoogle();
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PhoneVerificationPage(user),
                              ));
                        }
                      }
                    } on Exception catch (e) {
                      _email = null;
                      _password = null;
                      showDialog(
                        context: context,
                        builder: (context) => Text("Hata : " + e.toString()),
                      );
                    }
                    //  Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
