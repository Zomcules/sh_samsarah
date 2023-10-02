import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';

import '../../../../../models/message_data.dart';
import '../message_products_preview.dart';

class Message extends StatelessWidget {
  final MessageData data;
  Message({super.key, required this.data});

  final auth = AuthService();

  List<Widget> getContent() {
    List<Widget> temp = [];

    if (data.appendedProductsIds.isNotEmpty) {
      temp.add(MessageProductsPreview(
        ids: data.appendedProductsIds,
        key: UniqueKey(),
      ));
    }

    temp.add(Text(
      data.content,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      textWidthBasis: TextWidthBasis.parent,
    ));

    temp.add(Text(
      "${data.timeStamp.toDate().hour}:${data.timeStamp.toDate().minute}",
      style: const TextStyle(
          color: Color.fromARGB(255, 218, 218, 218), fontSize: 12),
    ));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: data.from == auth.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 4 / 5),
          margin: const EdgeInsets.only(top: 4, bottom: 4, right: 20, left: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: data.from == auth.uid
                    ? const Radius.circular(12)
                    : Radius.zero,
                topRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
                bottomRight: data.from != auth.uid
                    ? const Radius.circular(12)
                    : Radius.zero),
            color: data.from == auth.uid ? Colors.green : Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: data.from != auth.uid
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: getContent(),
            ),
          ),
        ),
      ],
    );
  }
}
