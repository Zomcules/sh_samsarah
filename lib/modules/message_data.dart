// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class MessageData extends HiveObject {
  final bool fromUser;
  final String content;
  bool isRead;
  final Timestamp timeStamp;
  final List<String> appendedProductsIds;
  MessageData(
      {required this.fromUser,
      required this.content,
      required this.timeStamp,
      this.isRead = false,
      required this.appendedProductsIds});

  factory MessageData.fromMap(Map map) {
    return MessageData(
        fromUser: map["fromUser"],
        content: map["content"],
        timeStamp: map["timeStamp"],
        appendedProductsIds: map["appendedProductsIds"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "fromUser": fromUser,
      "content": content,
      "timeStamp": timeStamp,
      "isRead": isRead,
      "appendedProductsIds": appendedProductsIds
    };
  }
}
