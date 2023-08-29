import 'dart:math';
import 'package:hive/hive.dart';
import 'package:samsarah/chat_app/chat_page/message.dart';
import 'package:samsarah/util/database/database.dart';

class AccountInfo extends HiveObject {
  String username;
  String? imagePath;
  String globalId;
  MessageData? lastMessage;
  List<String> productIds;
  int currency;

  AccountInfo(
      {this.lastMessage,
      required this.username,
      required this.globalId,
      this.imagePath,
      required this.productIds,
      required this.currency});

  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
        username: map["username"],
        globalId: map["globalId"],
        imagePath: map["imagePath"],
        lastMessage: map["lastMessage"],
        productIds: map["productIds"].cast<String>().toList(),
        currency: map["currency"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "globalId": globalId,
      "imagePath": imagePath,
      "lastMessage": lastMessage,
      "productIds": productIds,
      "currency": currency
    };
  }

  factory AccountInfo.dummy({String? globalId}) {
    var db = DataBase();
    bool signed = db.activeBox.isNotEmpty;
    var ran = Random().nextInt(999999).toString();
    if (signed) {
      ran = generateDummyId(signed ? db.accountInfos.values.toList() : []);
      db.addDummyMessages(localId: ran);
    }
    return AccountInfo(
        globalId: globalId ?? ran,
        username: "Dummy ${globalId ?? ran}",
        productIds: [],
        currency: 0);
  }

  factory AccountInfo.blank() {
    return AccountInfo(username: "", globalId: "", productIds: [], currency: 0);
  }
}

List<AccountInfo> getDummyAccountInfos({int? n = 20}) {
  List<AccountInfo> temp = [];
  for (var i = 0; i < n!; i++) {
    temp.add(AccountInfo.dummy());
  }
  return temp;
}

String generateDummyId(List inList) {
  DataBase db = DataBase();
  bool found = false;
  String temp;
  do {
    temp = Random().nextInt(999999).toString();
    var list = db.accountInfos.values.toList();

    for (var account in list) {
      if (account.globalId == temp) {
        found = true;
      }
    }
  } while (found == true);
  return temp.toString();
}
