import 'package:flutter/material.dart';

import 'package:conversa/widgets/new_messages.dart';
import 'package:conversa/widgets/prev_messages.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   setUpPushNotification();
  // }

  // void setUpPushNotification() async {
  //   final fcm = FirebaseMessaging.instance;

  //   await fcm.requestPermission();

  //   final token = await fcm.getToken();

  //   print("the token is : $token");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '𝕮𝖔𝖓𝖛𝖊𝖗𝖘𝖆',
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            Expanded(
              child: PrevMessages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
