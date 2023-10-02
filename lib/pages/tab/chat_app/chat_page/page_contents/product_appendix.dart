import 'package:flutter/material.dart';
import 'package:samsarah/util/tools/extensions.dart';

import '../../../../../models/product_info.dart';

class ProductAppendix extends StatelessWidget {
  final List<ProductInfo> infos;
  final VoidCallback onDismissed;
  const ProductAppendix(
      {super.key, required this.infos, required this.onDismissed});

  Widget getChild() {
    String title;
    Widget icon;
    if (infos.length == 1) {
      title = infos[0].price.annotate();
      icon = const Icon(Icons.bookmark);
    } else {
      title = "مجموعة من العروض";
      icon = const Icon(Icons.my_library_books_outlined);
    }
    return ListTile(
      title: Text(title),
      leading: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onDismissed: (direction) => onDismissed(),
        key: ValueKey(this),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.amber),
            child: getChild(),
          ),
        ));
  }
}
