import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/pages/tab/chat_app/profile.dart';
import 'package:samsarah/services/database_service.dart';
import '../../../models/account_info.dart';
import '../../../util/tools/poppers_and_pushers.dart';
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
  final _store = Database();
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
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () => push(
                          context,
                          ProfilePage(
                            account: snapshot.data!,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfilePhoto(
                            username: snapshot.data!.username,
                            radius: 30,
                            imagePath: snapshot.data!.imagePath),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () =>
                          push(context, ChatPage(reciever: snapshot.data!)),
                      child: Expanded(
                        child: Text(
                          snapshot.data!.username,
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(height: 80, child: CircularProgressIndicator());
        });
  }
}
