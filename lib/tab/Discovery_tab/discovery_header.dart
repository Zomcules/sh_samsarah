import 'package:flutter/material.dart';

import '../../util/product_info/product_info.dart';
import '../../util/product_info/product_preview_page.dart';
import '../../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

class DisHeader extends StatelessWidget {
  const DisHeader({super.key});

  void searchButtonTapped(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute<ProductInfo>(
          builder: (context) =>
              const ProductPreviewPage(type: PPPType.createNew),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow[200],
      // height: 200,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //button
          SizedBox(
            width: 100,
            child: Center(
              child: FloatingActionButton(
                onPressed: () => searchButtonTapped(context),
                shape: const CircleBorder(),
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Column(children: [
              Text(
                "استخدم ميزة البحث لاختيار العرض الذي يناسبك",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
