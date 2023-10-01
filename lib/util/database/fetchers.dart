import 'dart:async';

import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/models/product_info.dart';

import '../../models/account_info.dart';

final store = Database();
Future<AccountInfo> fetchAccount(String id) async {
  return await store.getAccount(id);
}

FutureOr<ProductInfo> fetchProduct(String id) async {
  return await store.getProduct(id);
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
