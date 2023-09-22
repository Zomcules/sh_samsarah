import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/util/tools/extensions.dart';

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

  Future<ProductInfo> getProduct(String id) async {
    return (await productCollection.doc(id).get()).data() ??
        ProductInfo.blank();
  }

  Future<AccountInfo> getAccount(String id) async {
    return (await accountCollection.doc(id).get()).data() ??
        AccountInfo.blank();
  }

  Future<List<ProductInfo>> getProductsOf(String uid) async {
    return (await productCollection.where("producerId", isEqualTo: uid).get())
        .docs
        .translate((element) => element.data());
  }

  Future<List<String>> getProductIdsOf(String uid) async {
    return (await getProductsOf(uid)).translate((element) => element.globalId);
  }

  Future<List<String>> savedProductsIdsOf(String uid) async {
    return (await getAccount(uid)).savedProducts;
  }

  Stream<DocumentSnapshot<AccountInfo>> accountStreamOf(String uid) =>
      accountCollection.doc(uid).snapshots();

  saveProduct(ProductInfo temp) async {
    await accountCollection.doc(AuthService().uid).update({
      "productIds": FieldValue.arrayUnion([temp.globalId])
    });
    await productCollection.doc(temp.globalId).set(temp);
  }
}
