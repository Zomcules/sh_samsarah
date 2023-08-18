import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_snackbar.dart';
import 'package:samsarah/util/account/account_header.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/database.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  var db = DataBase();

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
            AccountHeader(
              setstate: () => setState(() {}),
            ),
            Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: db.accountInfos().length,
                    itemBuilder: (context, index) => ChatSnackBar(
                          accountInfo: db
                              .accountInfos()
                              .values
                              .toList()
                              .reversed
                              .elementAt(index),
                          refreshParent: () => setState(() {}),
                        ))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var info = AccountInfo.dummy();
            db.accountInfos().add(info);
            await db.openMessages();
            //setState(() {});
          },
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        ));
  }
}
