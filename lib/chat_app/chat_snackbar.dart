// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:samsarah/chat_app/chat_page/message.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/database.dart';

import '../util/tools/get_image.dart';
import '../util/tools/poppers_and_pushers.dart';
import 'chat_page/chat_page.dart';

class ChatSnackBar extends StatefulWidget {
  final AccountInfo accountInfo;
  final Function refreshParent;
  const ChatSnackBar(
      {super.key, required this.accountInfo, required this.refreshParent});

  @override
  State<ChatSnackBar> createState() => _ChatSnackBarState();
}

class _ChatSnackBarState extends State<ChatSnackBar> {
  var db = DataBase();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(widget.accountInfo.username),
          content: const Text("حذف المحادثة؟"),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: const Text(
                    "نعم",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                icon: const Text("رجوع"))
          ],
        ),
      ).then((value) async {
        if (value!) {
          await widget.accountInfo.delete();
          widget.refreshParent();
        }
      }),
      onTap: () async {
        await db.openMessages();
        if (mounted) {
          await push(
              context,
              ChatPage(
                reciever: widget.accountInfo,
              ));
        }
        setState(() {
          widget.accountInfo.lastMessage!.isRead = true;
        });
        widget.refreshParent();
      },
      leading: GetImage(
        imagePath: widget.accountInfo.imagePath ?? "",
        size: 35,
      ),
      title: Text(widget.accountInfo.username),
      subtitle: formatLastMessage(db.messages(widget.accountInfo).values.last),
      trailing: widget.accountInfo.lastMessage != null
          ? widget.accountInfo.lastMessage!.isRead
              ? null
              : Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                )
          : null,
    );
  }

  Text formatLastMessage(MessageData data) {
    widget.accountInfo.lastMessage = data;
    if (data.fromUser) {
      return Text("You: ${data.content}");
    } else {
      if (data.isRead) {
        return Text(data.content);
      } else {
        return Text(
          data.content,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }
    }
  }
}
