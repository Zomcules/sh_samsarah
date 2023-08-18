import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/page_contents/product_appendix.dart';

import '../chat_controller.dart';

class ChatFooter extends StatefulWidget {
  final ChatController controller;
  const ChatFooter({super.key, required this.controller});

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  List<Widget> getFooter() {
    List<Widget> temp = [
      Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      await widget.controller.locationPressed(context);
                      setState(() {});
                    },
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
                      controller: widget.controller.textController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      textAlignVertical: TextAlignVertical.bottom,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => setState(() {
                          widget.controller.sendMessage();
                        }),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ))
              ],
            ),
          )),
    ];
    if (widget.controller.appendedProducts.isNotEmpty) {
      temp.add(ProductAppendix(
        infos: widget.controller.appendedProducts,
        onDismissed: () {
          widget.controller.appendedProducts.clear();
        },
      ));
    }
    return temp.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: getFooter(),
    );
  }
}
