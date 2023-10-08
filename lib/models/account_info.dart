import 'dart:math';

class AccountInfo {
  String username;
  String? imagePath;
  String globalId;
  int currency;

  AccountInfo({
    required this.username,
    required this.globalId,
    this.imagePath,
    required this.currency,
  });

  factory AccountInfo.firestore(Map<String, dynamic> map) => AccountInfo(
        username: map["username"],
        globalId: map["globalId"],
        imagePath: map["imagePath"],
        currency: map["currency"],
      );

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "globalId": globalId,
      "imagePath": imagePath,
      "currency": currency,
    };
  }

  factory AccountInfo.dummy({String? globalId}) {
    var ran = Random().nextInt(999999).toString();
    return AccountInfo(
      globalId: globalId ?? ran,
      username: "Dummy ${globalId ?? ran}",
      currency: 0,
    );
  }

  factory AccountInfo.blank() {
    return AccountInfo(
      username: "NoData",
      globalId: "NoData",
      currency: 0,
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
