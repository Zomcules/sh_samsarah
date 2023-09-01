import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_snackbar.dart';
import 'package:samsarah/util/account/account_header.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/fetchers.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  var db = DataBase();
  late Future future;

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
              child: FutureBuilder(
                future: auth.chatRoomsOfUser(),
                builder: (context, rooms) => rooms.connectionState ==
                        ConnectionState.done
                    ? ListView.builder(
                        itemCount: rooms.data!.length,
                        itemBuilder: (context, index) => FutureBuilder(
                          future: fetchAccount(rooms.data![index]
                              .data()
                              .chatters
                              .where((element) => element != auth.uid)
                              .first),
                          builder: (context, account) =>
                              account.connectionState == ConnectionState.done
                                  ? ChatSnackBar(
                                      room: rooms.data![index].data(),
                                      accountInfo: account.data!,
                                      refreshParent: () => setState(() {}))
                                  : const CircularProgressIndicator(),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
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
