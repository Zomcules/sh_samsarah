// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';
import '../util/tools/get_image.dart';
import '../util/tools/poppers_and_pushers.dart';
import 'chat_page/chat_page.dart';

class ChatSnackBar extends StatefulWidget {
  final String chatter;
  final Function refreshParent;
  const ChatSnackBar({
    super.key,
    required this.chatter,
    required this.refreshParent,
  });

  @override
  State<ChatSnackBar> createState() => _ChatSnackBarState();
}

class _ChatSnackBarState extends State<ChatSnackBar> {
  var store = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: store.accountStreamOf(widget.chatter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var acc = snapshot.data!.data()!;
            return ListTile(
              onLongPress: () => showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(acc.username),
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
                  widget.refreshParent();
                }
              }),
              onTap: () async {
                await push(
                  context,
                  ChatPage(
                    reciever: widget.chatter,
                  ),
                );
                widget.refreshParent();
              },
              leading: GetImage(
                imagePath: acc.imagePath ?? "",
                size: 35,
              ),
              title: Text(acc.username),
              //subtitle: formatLastMessage(db.messages(widget.accountInfo).values.last),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            );
          }
          return const Placeholder();
        });
  }
}
