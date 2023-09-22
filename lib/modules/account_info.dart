import 'dart:math';
import 'package:hive/hive.dart';

class AccountInfo extends HiveObject {
  String username;
  String? imagePath;
  String globalId;
  List<String> savedProducts;
  int currency;

  AccountInfo({
    required this.username,
    required this.globalId,
    this.imagePath,
    required this.currency,
    required this.savedProducts,
  });

  factory AccountInfo.firestoreWierdo(Map<String, dynamic> map) {
    return AccountInfo(
      username: map["username"],
      globalId: map["globalId"],
      imagePath: map["imagePath"],
      currency: 0,
      savedProducts: (map["savedProducts"] as List<dynamic>).cast<String>(),
    );
  }

  factory AccountInfo.firestoreUser(Map<String, dynamic> map) {
    return AccountInfo(
      username: map["username"],
      globalId: map["globalId"],
      imagePath: map["imagePath"],
      currency: map["currency"],
      savedProducts: map["savedProducts"].cast<String>().toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "globalId": globalId,
      "imagePath": imagePath,
      "currency": currency,
      "savedProducts": savedProducts,
    };
  }

  factory AccountInfo.dummy({String? globalId}) {
    var ran = Random().nextInt(999999).toString();
    return AccountInfo(
      globalId: globalId ?? ran,
      username: "Dummy ${globalId ?? ran}",
      currency: 0,
      savedProducts: [],
    );
  }

  factory AccountInfo.blank() {
    return AccountInfo(
      username: "",
      globalId: "",
      currency: 0,
      savedProducts: [],
    );
  }
}

List<AccountInfo> getDummyAccountInfos({int? n = 20}) {
  List<AccountInfo> temp = [];
  for (var i = 0; i < n!; i++) {
    temp.add(AccountInfo.dummy());
  }
  return temp;
}
