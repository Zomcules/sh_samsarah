// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:samsarah/chat_app/chat_page/page_contents/body.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/footer.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/header.dart';
import 'package:samsarah/modules/account_info.dart';
import 'package:samsarah/modules/product_info.dart';

class ChatPage extends StatelessWidget {
  final AccountInfo reciever;
  final ProductInfo? appendedProduct;
  const ChatPage({super.key, this.appendedProduct, required this.reciever});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: ChatHeader(reciever: reciever)),
      body: Column(
        children: [
          ChatBody(reciever: reciever.globalId),
          ChatFooter(
            reciever: reciever.globalId,
          )
        ],
      ),
    );
  }
}
