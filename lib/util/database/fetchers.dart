import 'dart:async';

import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/modules/product_info.dart';

import '../../modules/account_info.dart';

final store = FireStoreService();
final auth = AuthService();
Future<AccountInfo> fetchAccount(String id) async {
  return await store.getAccount(id) ?? AccountInfo.blank();
}

FutureOr<ProductInfo> fetchProduct(String id) async {
  return await store.getProduct(id) ?? ProductInfo.blank();
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
