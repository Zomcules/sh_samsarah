import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/modules/message_data.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/product_appendix.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../modules/product_info.dart';

class ChatFooter extends StatefulWidget {
  final String reciever;
  const ChatFooter({super.key, required this.reciever});

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  final msg = ChatService();
  final auth = AuthService();
  final textController = TextEditingController();
  List<ProductInfo> appendedProducts = [];
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
    await push(
        context,
        ChooseProductPage(
          onTap: (context, info) => appendedProducts.add(info),
        ));
    setState(() {});
  }

  Future<void> trySendMessage() async {
    if (textController.text != "" || appendedProducts.isNotEmpty) {
      final data = MessageData(
          from: auth.uid!,
          content: textController.text,
          timeStamp: Timestamp.now(),
          appendedProductsIds: List<String>.generate(appendedProducts.length,
              (index) => appendedProducts[index].globalId));
      if (!(await msg.sendMessage(data, widget.reciever))) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text("Network Issue!"),
            ),
          );
        }
      } else {
        appendedProducts.clear();
        textController.clear();
      }
    }
  }
}
