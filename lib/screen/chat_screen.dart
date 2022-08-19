import 'package:chatting_app2/chatRoom/chatList.dart';
import 'package:chatting_app2/chatRoom/sendMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Firebase Authentication
  final _authentication = FirebaseAuth.instance;

  // 현 User uid와 같은 정보를 담음 
  User? loggedUser;

  // 현재 User를 조회하는 Method
  void getCurrentUser() {
    final user = _authentication.currentUser;
    if (user != null) {
      loggedUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _authentication.signOut();

              // Navigator.of(context).pop();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // 채팅 리스트를 보여주는 Container
            Expanded(
              child: ChatList(),
            ),

            // 채팅 메시지를 보여주는 Container
            SendMessage(),
          ],
        ),
      ),
    );
  }
}


