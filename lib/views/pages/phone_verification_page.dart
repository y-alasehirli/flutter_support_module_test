import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/person/person.dart';
import '../../static/pods.dart';
import '../widgets/custom_button.dart';
import 'home_page_landing.dart';

class PhoneVerificationPage extends ConsumerStatefulWidget {
  const PhoneVerificationPage(this._user, {Key? key}) : super(key: key);
  final User _user;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends ConsumerState<PhoneVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _phoneNumber;
  Person _userToPersonCnv(User user) {
    return Person(
        email: user.email,
        uid: user.uid,
        level: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL);
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
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.length < 10 || value.contains("+90")) {
                      return "Hatalı numara";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _phoneNumber = "+90$newValue";
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      suffixIcon: const Icon(Icons.mobile_friendly),
                      labelText: "Telefon",
                      hintText: "5553332211",
                      filled: true,
                      fillColor: Colors.lightBlue.withOpacity(0.1)),
                ),
                CustomImageButton(
                  title: "Onay Kodu iste",
                  child: Container(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _formKey.currentState!.save();
                        User? user = await ref
                            .read(fireAuthClient)
                            .verifyPhoneNLinkUser(
                                context, widget._user, _phoneNumber);
                        if (user != null) {
                          Person person = _userToPersonCnv(user);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePageLanding(person),
                              ),
                              (route) => false);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Hata" + e.toString())));
                      }
                    }
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
