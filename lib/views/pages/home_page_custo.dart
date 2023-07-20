import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/person/person.dart';
import '../../core/models/videocall/video_call.dart';
import '../../static/pods.dart';
import '../../static/ui_theme.dart';
import 'conversation_page.dart';
import 'video_call_page.dart';

class HomePageCusto extends ConsumerStatefulWidget {
  const HomePageCusto(this._person, {Key? key}) : super(key: key);

  final Person _person;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageCusto();
}

class _HomePageCusto extends ConsumerState<HomePageCusto> {
 late String hasMessage = "";
 
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      print("message arrived");
      print("gelen title : ${event.notification!.title}");
      print("gelen data : " + event.data.toString());
      VideoCall receiveVideoCall = VideoCall(
          channelName: event.data["channelName"],
          from: event.notification!.title);

      setState(() {
        hasMessage = event.notification!.title!;
      });

      if (event.data.length > 1) {
        UITheme.alertTextDialog(
            context, "${receiveVideoCall.from} görüntülü arama yapıyor", [
          ButtonBar(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Reddet")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallPage(
                              /*  channelName: receiveVideoCall.channelName! */),
                        )).then((value) => Navigator.pop(context));
                  },
                  child: const Text("Kabul et"))
            ],
          )
        ]);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(hasMessage);
    return StreamBuilder(
        builder: (context, AsyncSnapshot<List<Person>?> snapshot) {
          if (snapshot.hasData) {
            List<Person>? adminList = [];
            adminList = snapshot.data;
            if (adminList != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(adminList![index].photoURL!),
                      ),
                      title: Text(adminList[index].email!),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                  admin: adminList![index],
                                  custo: widget._person,
                                  isAdmin: false),
                            )).then((value) {
                          setState(() {
                            hasMessage = "";
                          });
                        });
                      },
                      trailing: hasMessage == adminList[index].email
                          ? const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            )
                          : const SizedBox(),
                    ),
                  );
                },
                itemCount: adminList.length,
              );
            } else {
              return const Text("Sisteme kayıtlı support yok");
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
        stream: ref.watch(firePersonDB).getAdminList());
  }
}
