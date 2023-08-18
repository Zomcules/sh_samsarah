import 'package:flutter/material.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/database.dart';

import '../../../util/product_info/product_info.dart';
import '../../../util/tools/poppers_and_pushers.dart';
import 'choose_product_page.dart';
import 'message.dart';

class ChatController {
  final AccountInfo reciever;
  List<ProductInfo> appendedProducts;
  ChatController({required this.reciever, required this.appendedProducts});

  var db = DataBase();

  var scrollController = ScrollController();

  var textController = TextEditingController();

  void sendMessage() {
    if (textController.text != "" || appendedProducts.isNotEmpty) {
      var data = MessageData(
          fromUser: true,
          content: textController.text,
          dateTime: DateTime.now(),
          appendedProductsIds: List<String>.generate(appendedProducts.length,
              (index) => appendedProducts[index].globalId),
          isRead: true);
      db.messages(reciever).add(data);
      reciever.lastMessage = data;
      reciever.save();

      if (data.content == "fuck") {
        db.messages(reciever).add(MessageData(
            fromUser: false,
            content: "Bro just shut up...",
            dateTime: DateTime.now(),
            appendedProductsIds: []));
      }
      reciever.delete();
      db.accountInfos().add(reciever);
    }
    appendedProducts.clear();
    textController.clear();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Future<void> locationPressed(BuildContext context) async {
    await push(context, ChooseProductPage(onTap: (context, info) {
      appendedProducts.add(info);
      pop(context, null);
    }));
  }
}
