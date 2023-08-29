import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_info.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? size;
  const MyText(
      {super.key,
      this.color = const Color.fromARGB(255, 71, 172, 255),
      required this.text,
      this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: size!.toDouble()),
      ),
    );
  }
}

List<Widget> getAttributes(ProductInfo productInfo) {
  List<Widget> temp = [];
  temp.add(productInfo.forSale
      ? const MyText(
          text: "للبيع",
          color: Colors.red,
        )
      : const MyText(
          text: "للايجار",
          color: Colors.green,
        ));
  temp.add(const MyText(text: "سكني"));
  if (productInfo.floorsNum != 1) {
    temp.add(MyText(text: "${productInfo.floorsNum} عدد الطوابق"));
  }
  if (productInfo.roomsNum != null) {
    temp.add(MyText(text: "${productInfo.floorsNum} عدد الغرف"));
  }
  if (productInfo.nasiah != null) {
    if (productInfo.nasiah == false) {
      temp.add(const MyText(text: " ناصية"));
    }
  }
  if (productInfo.wholeHouse != null) {
    if (productInfo.wholeHouse == true) {
      temp.add(const MyText(text: "بيت كامل"));
    } else {
      temp.add(const MyText(text: "شقة"));
    }
  }

  temp.add(MyText(text: productInfo.zone.name));
  return temp;
}
