import 'package:chatting_app2/chatRoom/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    // Firebase DataBase에 있는 채팅들을 구독하고 있는 StreamBuilder
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            return Chat_Bubble(
              text: docs[index]['text'],
              isMe:
                  docs[index]['user'] == FirebaseAuth.instance.currentUser!.uid,
              userName: docs[index]['userName'],
              image_url: docs[index]['image_url'],
            );
          },
        );
      },
    );
  }
}
