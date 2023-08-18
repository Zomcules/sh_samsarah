import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../util/database/fetchers.dart';
import '../../util/product_info/product_info.dart';
import 'choose_product_page.dart';

class MessageProductsPreview extends StatefulWidget {
  final List<String> ids;
  const MessageProductsPreview({super.key, required this.ids});

  @override
  State<MessageProductsPreview> createState() => _MessageProductsPreviewState();
}

class _MessageProductsPreviewState extends State<MessageProductsPreview> {
  late Future<List<ProductInfo>> futureProducts;

  Future<List<ProductInfo>> theFuture() async {
    List<ProductInfo> temp = [];
    for (var id in widget.ids) {
      temp.add(await fetchProduct(id));
    }
    return temp;
  }

  @override
  initState() {
    super.initState();
    futureProducts = theFuture();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => push(
                context,
                ChooseProductPage(
                  products: snapshot.data,
                  onTap: (context, info) => push(
                      context,
                      ProductPreviewPage(
                        type: PPPType.viewExternal,
                        info: info,
                      )),
                )),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellow.shade200,
              ),
              width: 150,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          snapshot.data!.length > 1
                              ? Icons.my_library_books
                              : Icons.map,
                          color: Colors.brown,
                        ),
                        Text(
                          snapshot.data!.length > 1
                              ? "عدد من العروض"
                              : snapshot.data!.first.price.annotate(),
                          style: const TextStyle(color: Colors.brown),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
