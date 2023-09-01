import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/message.dart';

import '../../../services/chat_service.dart';

class ChatBody extends StatefulWidget {
  final ChatService service;
  const ChatBody({super.key, required this.service});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: widget.service.messages,
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
