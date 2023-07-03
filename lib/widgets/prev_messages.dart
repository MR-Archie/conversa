import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class PrevMessages extends StatelessWidget {
  const PrevMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          const Center(
            child: Text('No messages found.'),
          );
        }

        if (!chatSnapshots.hasError) {
          const Center(
            child: Text('Oops!! Something went wrong...'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 30,
            top: 20,
          ),
          itemCount: loadedMessages.length,
          reverse: true,
          itemBuilder: (ctx, index) {
            return Text(loadedMessages[index].data()['text']);
          },
        );
      },
    );
  }
}
