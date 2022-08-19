import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  SendMessage({Key? key}) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String sendMessage = '';
  TextEditingController tec = TextEditingController();

  // SendIcon을 눌렀을 떄 동작하는  Method
  void sendIconClick() async {
    // 키보드 해제
    FocusScope.of(context).unfocus();

    // TextField에 있던 데이터 없애기
    tec.clear();

    // Firebase DataBase에 데이터 추가하기
    User user = FirebaseAuth.instance.currentUser!;
    final userName =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
        
    FirebaseFirestore.instance.collection('chat').add({
      'text': sendMessage,
      'time': Timestamp.now(),
      'user': user.uid,
      'userName': userName.data()!['userName'],
      'image_url': userName.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: tec,
              decoration: InputDecoration(
                hintText: '메시지를 입력해주세요',
              ),
              onChanged: (value) {
                sendMessage = value;
              },
            ),
          ),
          IconButton(
            onPressed: sendMessage.trim().isEmpty ? null : sendIconClick,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
