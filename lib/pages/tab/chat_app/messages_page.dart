import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/chat_app/chat_snackbar.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/util/account/account_header.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _msg = ChatService();
  final _auth = AuthService();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  @override
  void initState() {
    super.initState();
    _stream = _msg.userChatRooms;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Samsarah",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const AccountHeader(),
          Expanded(
            child: StreamBuilder(
                stream: _stream,
                builder: (context, rooms) {
                  if (rooms.hasError) {
                    return Text(
                        "Error MessagesPage: ${rooms.error.toString()}");
                  }
                  if (rooms.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                      itemCount: rooms.data!.size,
                      itemBuilder: (context, index) => ChatSnackBar(
                            chatter: (rooms.data!.docs[index].data()["chatters"]
                                    as List<dynamic>)
                                .cast<String>()
                                .firstWhere((element) => element != _auth.uid),
                          ));
                }),
          ),
        ],
      ),
    );
  }
}
