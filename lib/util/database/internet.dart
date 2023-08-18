// ignore_for_file: await_only_futures

import 'dart:async';
import 'dart:math';

import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import '../../chat_app/chat_page/message.dart';
import 'database.dart';

class Internet {
  var mock = MockBase();

  Future<AccountInfo> getAccount(String id) async {
    return AccountInfo.fromMap(await mock.getAccountMap(id));
  }

  Future<ProductInfo> getProduct(String id) async {
    return await ProductInfo.fromMap(await mock.getProductMap(id));
  }

  Future<MessageData> getMessage(String id) async {
    return MessageData.fromMap(await mock.getMessageMap(id));
  }
}

class MockBase {
  Future<Map<String, dynamic>> getAccountMap(String id) async {
    return await AccountInfo.dummy().toMap();
  }

  Future<Map<String, dynamic>> getProductMap(String id) async {
    return await ProductInfo.dummy(DataBase().savedProducts().values.toList())
        .toMap();
  }

  Future<Map<String, dynamic>> getMessageMap(String id) async {
    return await MessageData(
        fromUser: Random().nextBool(),
        content: "content",
        dateTime: DateTime.now(),
        appendedProductsIds: []).toMap();
  }
}

FutureOr<List<ProductInfo>> productsFromGlobalIds(List<String> ids) async {
  var db = DataBase();
  List<ProductInfo> temp = [];
  for (var id in ids) {
    var list =
        db.savedProducts().values.where((element) => element.globalId == id);
    if (list.isNotEmpty) {
      temp.add(list.first);
    } else {
      temp.add(await Internet().getProduct(id));
    }
  }
  return temp;
}
