import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/search_page.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class DisHeader extends StatelessWidget {
  const DisHeader({super.key});

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
                onPressed: () => push(
                    context,
                    SearchPage(
                      pc: ProductController(),
                    )),
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
