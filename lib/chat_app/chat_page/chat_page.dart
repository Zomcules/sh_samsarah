// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:samsarah/chat_app/chat_page/page_contents/body.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/footer.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/header.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  final ProductInfo? appendedProduct;
  final AccountInfo reciever;
  const ChatPage({super.key, required this.reciever, this.appendedProduct});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController controller;
  @override
  void initState() {
    super.initState();
    controller =
        ChatController(reciever: widget.reciever, appendedProducts: []);
    if (widget.appendedProduct != null) {
      controller.appendedProducts.add(widget.appendedProduct!);
    }
  }

  var db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: ChatHeader(reciever: widget.reciever)),
      body: Column(
        children: [
          ChatBody(controller: controller),
          ChatFooter(
            controller: controller,
          )
        ],
      ),
    );
  }
}
