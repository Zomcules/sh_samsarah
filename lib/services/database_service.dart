import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/pages/tab/auth_flow/activate_voucher.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../models/account_info.dart';
import '../models/product_info.dart';

class Database {
  FirebaseFirestore get instance => FirebaseFirestore.instance;
  get auth => AuthService();

  Future<ProductInfo?> getProductPreferCache(String id) async {
    try {
      return (await productCollection
              .doc(id)
              .get(const GetOptions(source: Source.cache)))
          .data();
    } catch (e) {
      return (await productCollection
              .doc(id)
              .get(const GetOptions(source: Source.server)))
          .data();
    }
  }

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

  Future<int> publishPrice() async {
    return (await instance.collection("AppData").doc("Prices").get())
        .data()!["publishPrice"];
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

  Future<void> tryPublishProduct(
      BuildContext context, ProductInfo product) async {
    var price = 0;
    var currency = 0;

    bool eligable() => price <= currency;

    Future<void> init() async {
      price = await publishPrice();
      currency = await AuthService().getCurrency();
    }

    Future future = init();

    if (context.mounted) {
      bool? result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("نشر العرض"),
                content: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          Text(
                            "${currency.toString()} :رصيدك الان",
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            "سعر النشر: ${price.toString()}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          eligable()
                              ? const Text(
                                  "هل تريد عرض منتجك على التطبيق؟",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.green),
                                )
                              : const Text(
                                  "نأسف ولكن يبدون ان ليس لديك رصيد كافي",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                )
                        ],
                      );
                    }),
                actions: [
                  FutureBuilder(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        if (snapshot.hasError) {
                          return const SizedBox();
                        }
                        return eligable()
                            ? MyButton(
                                onPressed: () => pop(context, true),
                                raised: true,
                                title: "موافق")
                            : MyButton(
                                onPressed: () =>
                                    push(context, const ActivateVoucherPage()),
                                raised: true,
                                title: "شحن رصيد");
                      }),
                  MyButton(
                      onPressed: () => pop(context, false),
                      raised: false,
                      title: "الرجوع")
                ],
              ));
      if (result != null) {
        if (result) {
          saveProduct(product);
          updateCurrency(0 - price);
          if (context.mounted) {
            pop(context, null);
          }
        }
      }
    }
  }
}
