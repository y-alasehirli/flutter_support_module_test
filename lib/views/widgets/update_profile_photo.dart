import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/person/person.dart';
import '../../static/pods.dart';
import '../../static/shorten.dart';
import '../../static/ui_theme.dart';

class UploadProfilePicWid extends ConsumerStatefulWidget {
  const UploadProfilePicWid(this._person,
      {required this.newPhotoPath, Key? key})
      : super(key: key);
  final Person _person;
  final Function newPhotoPath;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadProfilePicWidState();
}

class _UploadProfilePicWidState extends ConsumerState<UploadProfilePicWid> {
  XFile? _newPhotoPath;

  _profilePicCheck() {
    return _newPhotoPath == null
        ? Image.network(widget._person.photoURL ?? Shorten.noProfilePicUrl)
        : Image.file(File(_newPhotoPath!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "hero",
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _profilePicCheck(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.5)),
                    child: IconButton(
                        color: Colors.blue,
                        onPressed: () {
                          final ImagePicker _picker = ImagePicker();

                          UITheme.alertButtonNoTitleDialog(context, [
                            IconButton(
                                onPressed: () async {
                                  XFile? xFile = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (xFile != null) {
                                    setState(() {
                                      _newPhotoPath = xFile;
                                      widget.newPhotoPath(_newPhotoPath);
                                      Navigator.pop(context);
                                    });
                                    await ref
                                        .read(personVMPod.notifier)
                                        .uploadProfilePhoto(widget._person.uid!,
                                            "profile", xFile);
                                  }
                                },
                                icon: const Icon(CupertinoIcons.photo)),
                            IconButton(
                                onPressed: () async {
                                  XFile? xFile = await _picker.pickImage(
                                      source: ImageSource.camera);
                                  if (xFile != null) {
                                    setState(() {
                                      _newPhotoPath = xFile;
                                      widget.newPhotoPath(_newPhotoPath);
                                      Navigator.pop(context);
                                    });
                                    await ref
                                        .read(personVMPod.notifier)
                                        .uploadProfilePhoto(widget._person.uid!,
                                            "profile", xFile);
                                  }
                                },
                                icon: const Icon(CupertinoIcons.camera))
                          ]);
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
