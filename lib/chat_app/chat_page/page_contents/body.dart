import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:samsarah/util/database/database.dart';

import '../chat_controller.dart';
import '../message.dart';

class ChatBody extends StatefulWidget {
  final ChatController controller;
  const ChatBody({super.key, required this.controller});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable:
            DataBase().messages(widget.controller.reciever).listenable(),
        builder: (context, value, child) => ListView.builder(
          itemCount: value.length,
          controller: widget.controller.scrollController,
          reverse: true,
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          itemBuilder: (context, index) =>
              Message(data: value.values.toList().reversed.elementAt(index)),
        ),
      ),
    );
  }
}
