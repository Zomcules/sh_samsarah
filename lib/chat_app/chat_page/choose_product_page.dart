import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/pages/tab/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/util/database/fetchers.dart';

import '../../modules/product_info.dart';

class ChooseProductPage extends StatelessWidget {
  final Function(BuildContext context, ProductInfo info) onTap;
  final List<ProductInfo>? products;
  final store = FireStoreService();
  final auth = AuthService();
  ChooseProductPage({super.key, this.products, required this.onTap});

  Future<List<Widget>> widgetList(BuildContext context) async {
    List<Widget> temp = [];
    if (products == null) {
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("عروضي"), Divider()],
      ));
      for (ProductInfo product in await store.getProductsOf(auth.uid!)) {
        temp.add(ProductSnackBar(
          productInfo: product,
          onTap: () => onTap(context, product),
        ));
      }
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("العروض المحفوظة"), Divider()],
      ));
      for (String id in await store.savedProductsIdsOf(auth.uid ?? "")) {
        var product = await fetchProduct(id);
        temp.add(ProductSnackBar(
          productInfo: product,
          onTap: () => onTap(context, product),
        ));
      }
      return temp;
    }
    for (var product in products!) {
      temp.add(ProductSnackBar(
          productInfo: product, onTap: () => onTap(context, product)));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("اختر عرض للارسال")),
        body: FutureBuilder(
          future: widgetList(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => snapshot.data![index])
                  : const CircularProgressIndicator(),
        ));
  }
}
