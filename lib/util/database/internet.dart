// ignore_for_file: await_only_futures

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/product_info/product_info.dart';

class Internet {
  var accountCollection = FirebaseFirestore.instance.collection("Accounts");
  var productCollection = FirebaseFirestore.instance.collection("Products");

  Future<AccountInfo?> getAccount(String id) async {
    var docData = (await accountCollection.doc(id).get()).data();
    if (docData != null) {
      return AccountInfo.fromMap(docData);
    }
    return null;
  }

  Future<ProductInfo?> getProduct(String id) async {
    var docData = (await productCollection.doc(id).get()).data();
    if (docData != null) {
      return ProductInfo.fromMap(docData);
    }
    return null;
  }
}

// class MockBase {
//   Future<Map<String, dynamic>> getAccountMap(String id) async {
//     return await AccountInfo.dummy().toMap();
//   }

//   Future<Map<String, dynamic>> getProductMap(String id) async {
//     return await ProductInfo.dummy(DataBase().savedProducts().values.toList())
//         .toMap();
//   }

//   Future<Map<String, dynamic>> getMessageMap(String id) async {
//     return await MessageData(
//         fromUser: Random().nextBool(),
//         content: "content",
//         dateTime: DateTime.now(),
//         appendedProductsIds: []).toMap();
//   }
// }
