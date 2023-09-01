// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:samsarah/chat_app/chat_page/page_contents/body.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/footer.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/header.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/modules/product_info.dart';

class ChatPage extends StatefulWidget {
  final ChatService service;
  final ProductInfo? appendedProduct;
  const ChatPage({super.key, this.appendedProduct, required this.service});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: ChatHeader(reciever: widget.service.reciever)),
      body: Column(
        children: [
          ChatBody(service: widget.service),
          ChatFooter(
            service: widget.service,
          )
        ],
      ),
    );
  }
}
