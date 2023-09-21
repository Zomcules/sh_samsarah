import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';
import '../modules/account_info.dart';
import '../util/tools/get_image.dart';
import '../util/tools/poppers_and_pushers.dart';
import 'chat_page/chat_page.dart';

class ChatSnackBar extends StatefulWidget {
  final String chatter;
  const ChatSnackBar({
    super.key,
    required this.chatter,
  });

  @override
  State<ChatSnackBar> createState() => _ChatSnackBarState();
}

class _ChatSnackBarState extends State<ChatSnackBar> {
  final _store = FireStoreService();
  late Future<AccountInfo> future;
  @override
  void initState() {
    super.initState();
    future = _store.getAccount(widget.chatter);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onLongPress: () => showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(snapshot.data!.username),
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
                    ),
                    onTap: () {
                      push(
                        context,
                        ChatPage(
                          reciever: snapshot.data!,
                        ),
                      );
                    },
                    leading: GetImage(
                      imagePath: snapshot.data!.imagePath ?? "",
                      size: 35,
                    ),
                    title: Text(snapshot.data!.username),
                  ),
                )
              : const SizedBox(height: 80, child: CircularProgressIndicator());
        });
  }
}
