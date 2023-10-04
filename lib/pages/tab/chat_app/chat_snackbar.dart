import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/pages/tab/chat_app/profile.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/tools/my_button.dart';
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

class _ChatSnackBarState extends State<ChatSnackBar>
    with AutomaticKeepAliveClientMixin {
  final _store = Database();
  late Future<AccountInfo> future;
  @override
  void initState() {
    super.initState();
    future = _store.getAccount(widget.chatter);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfilePhoto(
                          username: snapshot.data!.username,
                          radius: 30,
                          imagePath: snapshot.data!.imagePath),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => push(
                        context,
                        ChatPage(reciever: snapshot.data!),
                      ),
                      onLongPress: () => tryLeaveChat(snapshot),
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data!.username,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox(
                height: 80, child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void tryLeaveChat(AsyncSnapshot<AccountInfo> snapshot) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حظر ${snapshot.data?.username}"),
        content: const Text("هل انت متأكد"),
        actions: [
          MyButton(
              onPressed: () => pop(context, false),
              raised: true,
              title: "الرجوع"),
          MyButton(
              onPressed: () => pop(context, true), raised: false, title: "نعم")
        ],
      ),
    );
    if (result != null) {
      if (result) {
        ChatService().leaveChat(snapshot.data!.globalId);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
