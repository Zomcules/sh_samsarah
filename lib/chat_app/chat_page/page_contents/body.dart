import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/message.dart';

import '../../../modules/message_data.dart';
import '../../../services/chat_service.dart';

class ChatBody extends StatefulWidget {
  final String reciever;
  const ChatBody({super.key, required this.reciever});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final msg = ChatService();
  late final Stream<QuerySnapshot<MessageData>> _stream;
  @override
  void initState() {
    super.initState();
    _stream = msg.messagesStreamOf(widget.reciever);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return const Text("error!");
            }
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) =>
                  Message(data: snapshot.data!.docs[index].data()),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
