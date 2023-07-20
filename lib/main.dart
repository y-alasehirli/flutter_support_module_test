import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/pages/landing_page.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print("gelen mesaj başlığı: ${message.notification!.title}");
  print('background message ${message.notification!.body}');
  print("data : ${message.data["score"]}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(theme: ThemeData(),
      debugShowCheckedModeBanner: false,/*  */
      title: 'Support Module',
      home: LandingPage(),
    );
  }
}
