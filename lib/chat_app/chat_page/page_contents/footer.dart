import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/models/message_data.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/product_appendix.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../models/product_info.dart';

class ChatFooter extends StatefulWidget {
  final String reciever;
  final ProductInfo? appendedProduct;
  const ChatFooter({super.key, required this.reciever, this.appendedProduct});

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  final msg = ChatService();
  final auth = AuthService();
  final textController = TextEditingController();
  List<ProductInfo> appendedProducts = [];
  @override
  initState() {
    super.initState();
    if (widget.appendedProduct != null) {
      appendedProducts.add(widget.appendedProduct!);
    }
  }

  List<Widget> get footer {
    List<Widget> temp = [
      Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: onLocationPressed,
                    icon: const Icon(Icons.add_location_alt,
                        color: Colors.green)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 205, 245, 200),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      textAlignVertical: TextAlignVertical.bottom,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: trySendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    ];
    if (appendedProducts.isNotEmpty) {
      temp.add(ProductAppendix(
        infos: appendedProducts,
        onDismissed: () {
          appendedProducts.clear();
        },
      ));
    }
    return temp.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: footer,
    );
  }

  void onLocationPressed() async {
    var prod =
        await push<ProductInfo>(context, ChooseProductPage.selectFromUser());
    if (prod != null) {
      appendedProducts.add(prod);
    }
    setState(() {});
  }

  void trySendMessage() {
    if (textController.text != "" || appendedProducts.isNotEmpty) {
      msg.sendMessage(
          MessageData(
              from: auth.uid!,
              content: textController.text,
              timeStamp: Timestamp.now(),
              appendedProductsIds:
                  appendedProducts.map((e) => e.globalId).toList()),
          widget.reciever);
      textController.clear();
      appendedProducts.clear();
    }
  }
}
