// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:samsarah/services/auth_service.dart';

class MessageData extends HiveObject {
  final String from;
  final String content;
  bool isRead;
  final Timestamp timeStamp;
  final List<String> appendedProductsIds;
  MessageData(
      {required this.from,
      required this.content,
      required this.timeStamp,
      this.isRead = false,
      required this.appendedProductsIds});

  bool get fromUser => AuthService().uid == from;

  factory MessageData.fromMap(Map map) {
    return MessageData(
        from: map["fromUser"],
        content: map["content"],
        timeStamp: map["timeStamp"] ?? Timestamp.now(),
        appendedProductsIds:
            (map["appendedProductsIds"] as List).cast<String>());
  }

  Map<String, dynamic> toFireStore() {
    return {
      "fromUser": from,
      "content": content,
      "timeStamp": FieldValue.serverTimestamp(),
      "isRead": isRead,
      "appendedProductsIds": appendedProductsIds
    };
  }
}
