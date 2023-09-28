import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/services/auth_service.dart';

import '../modules/account_info.dart';
import '../modules/product_info.dart';

class Database {
  FirebaseFirestore get instance => FirebaseFirestore.instance;
  get auth => AuthService();

  CollectionReference<AccountInfo> get accountCollection =>
      instance.collection("Accounts").withConverter<AccountInfo>(
            fromFirestore: (snapshot, options) {
              return AccountInfo.firestore(snapshot.data()!);
            },
            toFirestore: (value, options) => value.toMap(),
          );

  CollectionReference<ProductInfo> get productCollection =>
      instance.collection("Products").withConverter<ProductInfo>(
            fromFirestore: (snapshot, options) =>
                ProductInfo.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          );

  Future<ProductInfo> getProduct(String id) async {
    return (await productCollection.doc(id).get()).data() ??
        ProductInfo.blank();
  }

  Future<AccountInfo> getAccount(String id) async {
    return (await accountCollection.doc(id).get()).data() ??
        AccountInfo.blank();
  }

  Future<List<ProductInfo>> getProductsOf(String uid) async {
    return (await productCollection
            .where("producer.globalId", isEqualTo: uid)
            .get())
        .docs
        .map((element) => element.data())
        .toList();
  }

  Future<List<ProductInfo>> savedProductsOf(String uid) async {
    return (await productCollection
            .where("bookmarkers", arrayContains: uid)
            .get())
        .docs
        .map((e) => e.data())
        .toList();
  }

  Future<List<String>> getProductIdsOf(String uid) async {
    return (await getProductsOf(uid))
        .map((element) => element.globalId)
        .toList();
  }

  Stream<DocumentSnapshot<AccountInfo>> accountStreamOf(String uid) =>
      accountCollection.doc(uid).snapshots();

  saveProduct(ProductInfo temp) async {
    await productCollection.doc(temp.globalId).set(temp);
  }

  Future<int> voucherValue(String code) async {
    return (await instance
                .collection("AppData")
                .doc("Vouchers")
                .collection("Vouchers")
                .doc(code)
                .get())
            .data()?["value"] ??
        0;
  }

  Future<void> deleteVoucher(String code) async {
    await instance
        .collection("AppData")
        .doc("Vouchers")
        .collection("Vouchers")
        .doc(code)
        .delete();
  }

  Future<void> updateCurrency(int change) async {
    await accountCollection
        .doc(auth.uid)
        .update({"currency": FieldValue.increment(change)});
  }

  Future<void> likeProduct(String globalId) async {
    await productCollection.doc(globalId).update({
      "likers": FieldValue.arrayUnion([auth.uid])
    });
  }

  Future<void> unlikeProduct(String globalId) async {
    await productCollection.doc(globalId).update({
      "likers": FieldValue.arrayRemove([auth.uid])
    });
  }

  Future<void> addToSaved(String globalId) async {
    await productCollection.doc(globalId).update({
      "bookmarkers": FieldValue.arrayUnion([auth.uid])
    });
  }

  Future<void> removeFromSaved(String globalId) async {
    await productCollection.doc(globalId).update({
      "bookmarkers": FieldValue.arrayRemove([auth.uid])
    });
  }
}
