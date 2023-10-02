import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/pages/tab/tabs/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../../models/product_info.dart';

class ChooseProductPage extends StatelessWidget {
  final Function(BuildContext context, ProductInfo info) onTap;
  final List<ProductInfo>? products;
  final store = Database();
  final auth = AuthService();

  ChooseProductPage._({this.products, required this.onTap});

  factory ChooseProductPage.overrideForUser(
      {required Function(BuildContext context, ProductInfo info) onTap}) {
    return ChooseProductPage._(
      onTap: onTap,
    );
  }

  factory ChooseProductPage.viewUsers() {
    return ChooseProductPage._(
      onTap: (context, info) => push(
        context,
        ProductPreviewPage(
          type: PPPType.viewExternal,
          info: info,
        ),
      ),
    );
  }

  factory ChooseProductPage.viewProducts(List<ProductInfo> products) {
    return ChooseProductPage._(
      onTap: (context, info) => push(
        context,
        ProductPreviewPage(
          type: PPPType.viewExternal,
          info: info,
        ),
      ),
      products: products,
    );
  }

  factory ChooseProductPage.selectFromUser() {
    return ChooseProductPage._(
      onTap: pop,
    );
  }

  factory ChooseProductPage.selectFromProducts(List<ProductInfo> products) {
    return ChooseProductPage._(
      onTap: pop,
      products: products,
    );
  }

  Future<List<Widget>> widgetList(BuildContext context) async {
    List<Widget> temp = [];
    if (products == null) {
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("عروضي"), Divider()],
      ));
      for (ProductInfo product in await store.getProductsOf(auth.uid!)) {
        temp.add(
          ProductSnackBar.simple(
            product: product,
            onTap: (product) => onTap(context, product),
          ),
        );
      }
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("العروض المحفوظة"), Divider()],
      ));
      for (ProductInfo product in await store.savedProductsOf(auth.uid!)) {
        temp.add(
          ProductSnackBar.simple(
            product: product,
            onTap: (product) => onTap(context, product),
          ),
        );
      }
      return temp;
    }
    for (var product in products!) {
      temp.add(ProductSnackBar.simple(
          product: product, onTap: (product) => onTap(context, product)));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("العروض")),
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
