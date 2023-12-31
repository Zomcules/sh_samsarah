import 'package:flutter/material.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';
import '../../../../models/product_info.dart';
import 'choose_product_page.dart';

class MessageProductsPreview extends StatefulWidget {
  final List<String> ids;
  const MessageProductsPreview({super.key, required this.ids});

  @override
  State<MessageProductsPreview> createState() => _MessageProductsPreviewState();
}

class _MessageProductsPreviewState extends State<MessageProductsPreview>
    with AutomaticKeepAliveClientMixin {
  late Future<List<ProductInfo>> futureProducts;
  final db = Database();

  Future<List<ProductInfo>> theFuture() async {
    List<ProductInfo> temp = [];
    for (var id in widget.ids) {
      temp.add((await db.getProductPreferCache(id)) ?? ProductInfo.blank());
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
    super.build(context);
    return FutureBuilder(
      future: futureProducts,
      builder: (context, snapshot) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () =>
              push(context, ChooseProductPage.viewProducts(snapshot.data!)),
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
                  snapshot.connectionState == ConnectionState.done
                      ? Column(
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
                      : const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
