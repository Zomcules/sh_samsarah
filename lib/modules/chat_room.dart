import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/modules/message_data.dart';

class ChatRoom {
  final List<String> chatters;
  Timestamp lastUpdated;
  MessageData lastMessage;

  ChatRoom(
      {required this.lastMessage,
      required this.lastUpdated,
      required this.chatters});

  factory ChatRoom.fromMap(Map map) {
    return ChatRoom(
        lastMessage: map["lastMessage"],
        lastUpdated: map["lastUpdated"],
        chatters: map["reciever"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "lastMessage": lastMessage,
      "lastUpdated": lastUpdated,
      "reciever": chatters
    };
  }
}
