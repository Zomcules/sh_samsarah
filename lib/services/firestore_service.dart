import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/services/auth_service.dart';

import '../modules/account_info.dart';
import '../modules/product_info.dart';

class FireStoreService {
  FirebaseFirestore get instance => FirebaseFirestore.instance;

  CollectionReference<AccountInfo> get accountCollection =>
      instance.collection("Accounts").withConverter<AccountInfo>(
            fromFirestore: (snapshot, options) {
              return snapshot.data()?["globalId"] != AuthService().uid
                  ? AccountInfo.firestoreWierdo(snapshot.data()!)
                  : AccountInfo.firestoreUser(snapshot.data()!);
            },
            toFirestore: (value, options) => value.toMap(),
          );

  CollectionReference<ProductInfo> get productCollection =>
      instance.collection("Products").withConverter<ProductInfo>(
            fromFirestore: (snapshot, options) =>
                ProductInfo.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          );

  Future<ProductInfo?> getProduct(String id) async {
    return (await productCollection.doc(id).get()).data();
  }

  Future<void> saveProduct(ProductInfo info) async {
    await productCollection.doc(info.globalId).set(info);
  }

  Future<AccountInfo?> getAccount(String id) async {
    return (await accountCollection.doc(id).get()).data();
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

  Future<List<String>> savedProductsIdsOf(String uid) async {
    return (await getAccount(uid))?.savedProducts ?? [];
  }
}
