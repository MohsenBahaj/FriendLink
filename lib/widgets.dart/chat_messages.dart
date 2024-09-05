import 'package:chat/widgets.dart/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final authUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Messages'));
        }
        if (snapshot.hasError) {
          return Text('Something went Wrong...');
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMessage.length,
            itemBuilder: (ctx, index) {
              final currentMessage = loadedMessage[index].data();
              final nextMessage = index + 1 < loadedMessage.length
                  ? loadedMessage[index + 1].data()
                  : null;

              final currentUserUid = currentMessage['userId'];
              final nextUserUid =
                  nextMessage != null ? nextMessage['userId'] : null;

              // Determine if the next message is from the same user
              final bool nextUserIsSame = nextUserUid == currentUserUid;

              if (nextUserIsSame) {
                // Consecutive messages from the same user
                return MessageBubble.next(
                  message: currentMessage['text'],
                  isMe: authUser!.uid == currentUserUid,
                );
              } else {
                // First message from the user in this sequence
                return MessageBubble.first(
                  userImage: currentMessage['image'],
                  username: currentMessage['username'],
                  message: currentMessage['text'],
                  isMe: authUser!.uid == currentUserUid,
                );
              }
            });
      },
    );
  }
}
