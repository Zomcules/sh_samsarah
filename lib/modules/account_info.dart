import 'dart:math';
import 'package:hive/hive.dart';

class AccountInfo extends HiveObject {
  String username;
  String? imagePath;
  String globalId;
  List<String> productIds;
  List<String> savedProducts;
  List<String> chatters;
  int currency;

  AccountInfo(
      {required this.username,
      required this.globalId,
      this.imagePath,
      required this.productIds,
      required this.currency,
      required this.savedProducts,
      required this.chatters});

  factory AccountInfo.firestoreWierdo(Map<String, dynamic> map) {
    return AccountInfo(
        username: map["username"],
        globalId: map["globalId"],
        imagePath: map["imagePath"],
        productIds: map["productIds"].cast<String>().toList(),
        currency: 0,
        savedProducts: (map["savedProducts"] as List<dynamic>).cast<String>(),
        chatters: []);
  }

  factory AccountInfo.firestoreUser(Map<String, dynamic> map) {
    return AccountInfo(
        username: map["username"],
        globalId: map["globalId"],
        imagePath: map["imagePath"],
        productIds: map["productIds"].cast<String>().toList(),
        currency: map["currency"],
        savedProducts: map["savedProducts"].cast<String>().toList(),
        chatters: map["chatRooms"].cast<String>().toList());
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "globalId": globalId,
      "imagePath": imagePath,
      "productIds": productIds,
      "currency": currency,
      "savedProducts": savedProducts,
      "chatRooms": chatters
    };
  }

  factory AccountInfo.dummy({String? globalId}) {
    var ran = Random().nextInt(999999).toString();
    return AccountInfo(
        globalId: globalId ?? ran,
        username: "Dummy ${globalId ?? ran}",
        productIds: [],
        currency: 0,
        savedProducts: [],
        chatters: []);
  }

  factory AccountInfo.blank() {
    return AccountInfo(
        username: "",
        globalId: "",
        productIds: [],
        currency: 0,
        savedProducts: [],
        chatters: []);
  }
}

List<AccountInfo> getDummyAccountInfos({int? n = 20}) {
  List<AccountInfo> temp = [];
  for (var i = 0; i < n!; i++) {
    temp.add(AccountInfo.dummy());
  }
  return temp;
}
