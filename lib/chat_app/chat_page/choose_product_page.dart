import 'package:flutter/material.dart';
import 'package:samsarah/tab/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/util/database/database.dart';

import '../../../util/product_info/product_info.dart';

class ChooseProductPage extends StatelessWidget {
  final Function(BuildContext context, ProductInfo info) onTap;
  final List<ProductInfo>? products;
  final db = DataBase();
  ChooseProductPage({super.key, this.products, required this.onTap});

  List<Widget> widgetList(BuildContext context) {
    List<Widget> temp = [];
    if (products == null) {
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("عروضي"), Divider()],
      ));
      for (ProductInfo product in db.userProducts) {
        temp.add(ProductSnackBar(
          productInfo: product,
          onTap: () => onTap(context, product),
        ));
      }
      temp.add(const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Divider(), Text("العروض المحفوظة"), Divider()],
      ));
      for (ProductInfo product in db.otherProducts) {
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
        body: ListView.builder(
            itemCount: widgetList(context).length,
            itemBuilder: (context, index) => widgetList(context)[index]));
  }
}
