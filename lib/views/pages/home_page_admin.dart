import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/videocall/video_call.dart';
import '../../static/ui_theme.dart';
import 'video_call_page.dart';

import '../../core/models/person/person.dart';
import '../../static/pods.dart';
import 'conversation_page.dart';

class HomePageAdmin extends ConsumerStatefulWidget {
  const HomePageAdmin(this._person, {Key? key}) : super(key: key);

  final Person _person;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageCusto();
}

class _HomePageCusto extends ConsumerState<HomePageAdmin> {
  String hasMessage = "";
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
  Widget build(BuildContext context) {
    print(hasMessage);
    return StreamBuilder(
        builder: (context, AsyncSnapshot<List<Person>?> snapshot) {
          if (snapshot.hasData) {
            List<Person>? custoList = [];
            custoList = snapshot.data;
            if (custoList != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(custoList![index].photoURL!),
                      ),
                      title: Text(custoList[index].email!),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                  admin: widget._person,
                                  custo: custoList![index],
                                  isAdmin: true),
                            )).then((value) {
                          setState(() {
                            hasMessage = "";
                          });
                        });
                      },
                      trailing: hasMessage == custoList[index].email
                          ? const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            )
                          : const SizedBox(),
                    ),
                  );
                },
                itemCount: custoList.length,
              );
            } else {
              return const Text("Sisteme kayıtlı kullanıcı yok");
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
        stream: ref.watch(firePersonDB).getCustoList());
  }
}
