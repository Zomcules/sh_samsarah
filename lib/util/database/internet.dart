import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/product_info/product_info.dart';

class Net {
  Net() {
    var instance = FirebaseFirestore.instance;
    accountCollection =
        instance.collection("Accounts").withConverter<AccountInfo>(
              fromFirestore: (snapshot, options) =>
                  AccountInfo.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap(),
            );
    productCollection =
        instance.collection("Products").withConverter<ProductInfo>(
              fromFirestore: (snapshot, options) =>
                  ProductInfo.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap(),
            );
  }

  var auth = FirebaseAuth.instance;
  late CollectionReference<AccountInfo> accountCollection;
  late CollectionReference<ProductInfo> productCollection;

  Future<void> syncUser() async {
    accountCollection.doc(auth.currentUser!.uid).set((await currentAccount)!);
  }

  String? get uid => auth.currentUser?.uid;

  bool get isSignedIn => auth.currentUser != null;

  CollectionReference messagesWith(AccountInfo info) {
    return FirebaseFirestore.instance
        .collection("${auth.currentUser!.uid}-${info.globalId}");
  }

  Future<AccountInfo?> get currentAccount async {
    if (auth.currentUser != null) {
      return AccountInfo(
          username: auth.currentUser?.displayName ?? "",
          globalId: auth.currentUser!.uid,
          productIds: await _getProductIdsOf(auth.currentUser!.uid),
          currency: await getCurrencyOf(auth.currentUser!.uid));
    }
    return null;
  }

  Future<AccountInfo?> getAccount(String id) async {
    return (await accountCollection.doc(id).get()).data();
  }

  Future<ProductInfo?> getProduct(String id) async {
    return (await productCollection.doc(id).get()).data();
  }

  Future<List<String>> _getProductIdsOf(String uid) async {
    return (await accountCollection.doc(uid).get()).data()?.productIds ?? [];
  }

  Future<List<ProductInfo>> getProductsOf(String uid) async {
    var temp = <ProductInfo>[];
    for (String id in await _getProductIdsOf(uid)) {
      var data = (await productCollection.doc(id).get()).data();
      if (data != null) {
        temp.add(data);
      }
    }
    return temp;
  }

  Future<int> getCurrencyOf(String uid) async {
    return (await accountCollection.doc(uid).get()).data()?.currency ?? 0;
  }

  Future<void> saveProduct(ProductInfo info) async {
    await productCollection.doc(info.globalId).set(info);
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
