import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/person/person.dart';
import '../../static/hero_dialog_route.dart';
import '../../static/shorten.dart';
import '../widgets/custom_logout_button.dart';
import '../widgets/update_profile_photo.dart';
import 'home_page_admin.dart';
import 'home_page_custo.dart';

class HomePageLanding extends StatefulWidget {
  const HomePageLanding(this._person, {Key? key}) : super(key: key);

  final Person _person;

  @override
  State<HomePageLanding> createState() => _HomePageLandingState();
}

class _HomePageLandingState extends State<HomePageLanding> {
  Widget _setBodyPage() {
    if (widget._person.level == "admin") {
      return HomePageAdmin(widget._person);
    } else {
      return HomePageCusto(widget._person);
    }
  }

  XFile? _newPhotoPath;

  _profilePicCheck() {
    return _newPhotoPath == null
        ? NetworkImage(widget._person.photoURL ?? Shorten.noProfilePicUrl)
        : FileImage(File(_newPhotoPath!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(context, HeroDialogRoute(builder: (context) {
                return UploadProfilePicWid(
                  widget._person,
                  newPhotoPath: (photoPath) {
                    setState(() {
                      _newPhotoPath = photoPath;
                    });
                  },
                );
              }));
            },
            child: Hero(
              tag: "hero",
              child: CircleAvatar(
                backgroundImage: _profilePicCheck(),
              ),
            ),
          ),
        ),
        title: const Text("Support Module"),
        centerTitle: true,
        // ignore: prefer_const_constructors
        actions: const [CustomLogOutButton()],
      ),
      body: _setBodyPage(),
    );
  }
}
