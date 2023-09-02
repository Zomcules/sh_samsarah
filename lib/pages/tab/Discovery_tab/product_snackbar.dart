import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/Discovery_tab/discovery_header.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/location_preview.dart';
import 'package:samsarah/util/tools/my_text.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/modules/product_info.dart';

import '../../../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

List<Widget> getDummyProductSnackbars() {
  List<ProductInfo> tempp = getDummyProductInfos();
  List<Widget> tempw = [
    const DisHeader(),
    const Divider(
      endIndent: 20,
      indent: 20,
    )
  ];
  for (ProductInfo info in tempp) {
    tempw.add(ProductSnackBar(productInfo: info));
  }
  return tempw;
}

class ProductSnackBar extends StatelessWidget {
  final Function? onTap;
  final ProductInfo productInfo;
  const ProductSnackBar({super.key, required this.productInfo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap != null
          ? onTap!()
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductPreviewPage(
                    info: productInfo,
                    type: PPPType.viewExternal,
                  ))),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.15),
                  blurStyle: BlurStyle.outer)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LocationPreview(
                  geopoint: productInfo.geopoint,
                  pc: ProductController(),
                  type: PPPType.viewExternal,
                  validator: (_) => null),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.amber.shade300,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Row(
                          children: [
                            const Text(
                              "جنيه ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              productInfo.price.annotate(),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(.6),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Wrap(
                      //alignment: WrapAlignment.end,
                      textDirection: TextDirection.rtl,
                      children: getAttributes(productInfo))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}