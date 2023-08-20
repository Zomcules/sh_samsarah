import 'dart:async';

import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/internet.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import '../account/account_info.dart';

FutureOr<AccountInfo> fetchAccount(String id) async {
  var db = DataBase();
  if (db.activeBox().isNotEmpty) {
    var list =
        db.accountInfos().values.where((element) => element.globalId == id);
    if (list.isNotEmpty) {
      return list.first;
    }
  }
  return await Internet().getAccount(id) ?? AccountInfo.blank();
}

FutureOr<ProductInfo> fetchProduct(String id) async {
  var db = DataBase();
  if (db.activeBox().isNotEmpty) {
    var list =
        db.savedProducts().values.where((element) => element.globalId == id);
    if (list.isNotEmpty) {
      return list.first;
    }
  }
  return await Internet().getProduct(id) ?? ProductInfo.blank();
}

Future<List<ProductInfo>> fetchMultipleProducts(List<String> ids) async {
  var temp = <ProductInfo>[];
  for (var id in ids) {
    temp.add(await fetchProduct(id));
  }
  return temp;
}

Future<List<AccountInfo>> fetchMultipleAccounts(List<String> ids) async {
  var temp = <AccountInfo>[];
  for (var id in ids) {
    temp.add(await fetchAccount(id));
  }
  return temp;
}
