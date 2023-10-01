import 'package:flutter/material.dart';
import 'package:samsarah/models/product_info.dart';

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
  switch (productInfo.zone) {
    case ZoneType.agricultural:
      temp.add(
        const MyText(
          text: "زراعية",
          color: Colors.green,
        ),
      );
      break;
    case ZoneType.commercial:
      temp.add(
        const MyText(
          text: "تجارية",
          color: Colors.orange,
        ),
      );
      break;
    case ZoneType.residential:
      temp.add(
        const MyText(
          text: "سكنية",
          color: Colors.cyan,
        ),
      );
      break;
    default:
  }
  temp.addAll([
    productInfo.forSale
        ? const MyText(
            text: "للبيع",
            color: Colors.red,
          )
        : const MyText(
            text: "للايجار",
            color: Colors.green,
          ),
    MyText(text: "المساحة: ${productInfo.size}"),
  ]);

  if (productInfo.services != null) {
    if (productInfo.services!) {
      temp.add(const MyText(text: "خدمات متوفرة"));
    }
  }

  if (productInfo.zone == ZoneType.residential) {
    if (productInfo.floorsNum != 1) {
      temp.add(MyText(text: "${productInfo.floorsNum} عدد الطوابق"));
    }
    if (productInfo.roomsNum != null) {
      temp.add(MyText(text: "${productInfo.floorsNum} عدد الغرف"));
    }
    if (productInfo.nasiah != null) {
      if (productInfo.nasiah!) {
        temp.add(const MyText(text: " ناصية"));
      }
    }
    if (productInfo.wholeHouse != null) {
      if (productInfo.wholeHouse!) {
        temp.add(const MyText(text: "بيت كامل"));
      } else {
        temp.add(const MyText(text: "شقة"));
      }
    }
  }
  return temp;
}
