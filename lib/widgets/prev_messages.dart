import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversa/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class PrevMessages extends StatelessWidget {
  const PrevMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = (index + 1) < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentUserId = chatMessage['userId'];
            final nextUserId =
                (nextChatMessage != null) ? nextChatMessage['userId'] : null;
            final isNextUserSame = currentUserId == nextUserId;
            if (isNextUserSame) {
              return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: currentUserId == authenticatedUser.uid);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['userName'],
                  message: chatMessage['text'],
                  isMe: currentUserId == authenticatedUser.uid);
            }
          },
        );
      },
    );
  }
}
