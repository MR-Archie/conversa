import 'package:conversa/widgets/new_messages.dart';
import 'package:conversa/widgets/prev_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
