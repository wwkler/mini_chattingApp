import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

// 나와 상대방을 구별
class Chat_Bubble extends StatelessWidget {
  const Chat_Bubble({
    required this.text,
    required this.isMe,
    required this.userName,
    required this.image_url,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isMe;
  final String userName;
  final String image_url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // '나'일떄 Chat Bubble
            if (isMe)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatBubble(
                  clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 20, right: 30),
                  backGroundColor: Colors.grey[500],
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Column(
                      children: [
                        Text(
                          userName,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // '상대방'일 떄 Chat Bubble
            if (!isMe)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatBubble(
                  clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 20, left: 30),
                  backGroundColor: Colors.blue,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Column(
                      children: [
                        Text(
                          userName,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
        Positioned(
          left: isMe ? 360.0 : 0,
          right: !isMe ? 360.0 : 0,
          bottom: 50.0,
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
              image_url,
            ),
          ),
        )
      ],
    );
  }
}
