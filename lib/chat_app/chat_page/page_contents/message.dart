import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';

import '../../../modules/message_data.dart';
import '../message_products_preview.dart';

class Message extends StatefulWidget {
  final MessageData data;
  const Message({super.key, required this.data});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late List<String> ids;
  final auth = AuthService();
  @override
  initState() {
    super.initState();
    ids = List.from(widget.data.appendedProductsIds);
  }

  List<Widget> getContent() {
    List<Widget> temp = [];

    if (ids.isNotEmpty) {
      temp.add(MessageProductsPreview(ids: ids));
    }

    temp.add(Text(
      //ids.toString(),
      widget.data.content,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      textWidthBasis: TextWidthBasis.parent,
    ));

    temp.add(Text(
      "${widget.data.timeStamp.toDate().hour}:${widget.data.timeStamp.toDate().minute}",
      style: const TextStyle(
          color: Color.fromARGB(255, 218, 218, 218), fontSize: 12),
    ));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.data.from == auth.uid
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 4 / 5),
          margin: const EdgeInsets.only(top: 4, bottom: 4, right: 20, left: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: widget.data.from == auth.uid
                    ? const Radius.circular(12)
                    : Radius.zero,
                topRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
                bottomRight: widget.data.from != auth.uid
                    ? const Radius.circular(12)
                    : Radius.zero),
            color: widget.data.from == auth.uid ? Colors.green : Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: widget.data.from != auth.uid
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
