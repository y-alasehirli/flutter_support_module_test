import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/models/videocall/video_call.dart';
import '../widgets/make_video_call.dart';
import '../../static/ui_theme.dart';
import '../../static/hero_dialog_route.dart';
import '../widgets/show_profile_pic_widget.dart';
import '../../core/models/message/message.dart';
import '../../core/models/person/person.dart';
import '../../static/pods.dart';
import '../widgets/speech_bubble_widget.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({required this.admin, required this.custo, required this.isAdmin, Key? key}) : super(key: key);

  final Person admin;
  final Person custo;
  final bool isAdmin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdmin ? widget.custo.email! : widget.admin.email!),
        centerTitle: true,
        actions: [
          MakeVideoCallButton(
            videoCall: VideoCall(
                toFcmToken: !widget.isAdmin ? widget.admin.fcmToken : widget.custo.fcmToken,
                from: !widget.isAdmin ? widget.custo.email : widget.admin.email,
                to: !widget.isAdmin ? widget.admin.email : widget.custo.email,
                channelName: !widget.isAdmin ? widget.custo.uid : widget.admin.uid),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, HeroDialogRoute(
                  builder: (context) {
                    return ShowProfilePicWid(
                      !widget.isAdmin ? widget.admin.photoURL! : widget.custo.photoURL!,
                      isDownloadable: false,
                    );
                  },
                ));
              },
              child: Hero(
                tag: !widget.isAdmin ? widget.admin.photoURL! : widget.custo.photoURL!,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(!widget.isAdmin ? widget.admin.photoURL! : widget.custo.photoURL!),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              builder: (context, AsyncSnapshot<List<Message>?> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: SpeechBubble(snapshot.data![index], widget.isAdmin ? widget.admin : widget.custo),
                        onLongPress: () async {
                          await ref.read(messageVMPod).deleteMessage(snapshot.data![index], widget.isAdmin);
                        },
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              stream: ref.watch(messageVMPod).getMessages(widget.custo, widget.admin),
            ),
          ),
          Material(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 7.0, left: 7.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Material(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  final ImagePicker _picker = ImagePicker();

                                  UITheme.alertButtonNoTitleDialog(context, [
                                    IconButton(
                                        onPressed: () async {
                                          XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
                                          if (xFile != null) {
                                            Message _savingMessage = Message(
                                                toFcmToken: !widget.isAdmin ? widget.admin.fcmToken : widget.custo.fcmToken,
                                                from: !widget.isAdmin ? widget.custo.uid : widget.admin.uid,
                                                to: !widget.isAdmin ? widget.admin.uid : widget.custo.uid,
                                                admin: widget.admin.uid);
                                            await ref.read(messageVMPod).savePicture(_savingMessage, "picmessages", xFile);
                                            await ref
                                                .read(notification)
                                                .pushNotification(_savingMessage, !widget.isAdmin ? widget.custo : widget.admin);
                                            Navigator.pop(context);
                                          }
                                        },
                                        icon: const Icon(CupertinoIcons.photo)),
                                    IconButton(
                                        onPressed: () async {
                                          XFile? xFile = await _picker.pickImage(source: ImageSource.camera);
                                          if (xFile != null) {
                                            Message _savingMessage = Message(
                                                toFcmToken: !widget.isAdmin ? widget.admin.fcmToken : widget.custo.fcmToken,
                                                from: !widget.isAdmin ? widget.custo.uid : widget.admin.uid,
                                                to: !widget.isAdmin ? widget.admin.uid : widget.custo.uid,
                                                admin: widget.admin.uid);
                                            await ref.read(messageVMPod).savePicture(_savingMessage, "picmessages", xFile);
                                            await ref
                                                .read(notification)
                                                .pushNotification(_savingMessage, !widget.isAdmin ? widget.custo : widget.admin);
                                            Navigator.pop(context);
                                          }
                                        },
                                        icon: const Icon(CupertinoIcons.camera))
                                  ]);
                                },
                                child: const Icon(Icons.add_a_photo_outlined),
                              ),
                              hintText: "Mesaj yazınız",
                              border: const UnderlineInputBorder(borderSide: BorderSide.none)),
                        ),
                      ),
                      color: Colors.white,
                    )),
                    IconButton(
                      onPressed: () async {
                        if (_textEditingController.text.trim().isNotEmpty) {
                          Message _savingMessage = Message(
                              toFcmToken: !widget.isAdmin ? widget.admin.fcmToken : widget.custo.fcmToken,
                              content: _textEditingController.text,
                              from: !widget.isAdmin ? widget.custo.uid : widget.admin.uid,
                              to: !widget.isAdmin ? widget.admin.uid : widget.custo.uid,
                              admin: widget.admin.uid);

                          bool bResult = await ref.read(messageVMPod).saveMessage(_savingMessage, widget.isAdmin);
                          await ref.read(notification).pushNotification(_savingMessage, !widget.isAdmin ? widget.custo : widget.admin);
                          if (bResult) {
                            _textEditingController.clear();
                            _scrollController.animateTo(0, duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
                          }
                        }
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
