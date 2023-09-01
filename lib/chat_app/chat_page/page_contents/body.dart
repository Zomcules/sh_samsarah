import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/message.dart';

import '../../../services/chat_service.dart';

class ChatBody extends StatefulWidget {
  final String reciever;
  const ChatBody({super.key, required this.reciever});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final msg = ChatService();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: msg.messagesStreamOf(widget.reciever),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) =>
                Message(data: snapshot.data!.docs[index].data()),
          );
        },
      ),
    );
  }
}
