import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_snackbar.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/util/account/account_header.dart';
import 'package:samsarah/util/database/fetchers.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final msg = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Samsarah",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            const AccountHeader(),
            Expanded(
              child: StreamBuilder(
                  stream: msg.userChatRooms,
                  builder: (context, rooms) {
                    return rooms.hasData
                        ? ListView.builder(
                            itemCount: rooms.data!.size,
                            itemBuilder: (context, index) => StreamBuilder(
                              stream: store.accountStreamOf(
                                  (rooms.data!.docs[index].data()["chatters"]
                                          as List<String>)
                                      .firstWhere(
                                          (element) => element != auth.uid)),
                              builder: (context, account) => account.hasData
                                  ? ChatSnackBar(
                                      chatter: account.data!.data()!.globalId,
                                      refreshParent: () => setState(() {}))
                                  : const CircularProgressIndicator(),
                            ),
                          )
                        : const CircularProgressIndicator();
                  }),
            ),
          ],
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.blue,
          shape: CircleBorder(),
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
        ));
  }
}
