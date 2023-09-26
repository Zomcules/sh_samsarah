import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/location_preview.dart';
import 'package:samsarah/util/tools/my_text.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/modules/product_info.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

class ProductSnackBar extends StatelessWidget {
  final Widget widget;
  final void Function(ProductInfo product)? onTap;
  final ProductInfo product;

  const ProductSnackBar._(
      {required this.onTap, required this.product, required this.widget});

  factory ProductSnackBar.simple(
      {required void Function(ProductInfo info)? onTap,
      required ProductInfo product}) {
    return ProductSnackBar._(
      onTap: onTap,
      product: product,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onTap != null ? onTap(product) : null,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.15),
                      blurStyle: BlurStyle.outer)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  MyText(
                    text: product.forSale ? "للبيع" : "للشراء",
                    color: product.forSale ? Colors.red : Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(product.price.annotate()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  factory ProductSnackBar.post(
      {required void Function(ProductInfo info)? onTap,
      required ProductInfo product}) {
    return ProductSnackBar._(
      onTap: onTap,
      product: product,
      widget: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap != null ? onTap(product) : null,
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LocationPreview(
                        geopoint: product.geopoint,
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    product.price.annotate(),
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
                            children: getAttributes(product))
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Bookmark(product: product), Likes(product: product)],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget;
}

class Likes extends StatefulWidget {
  final ProductInfo product;
  const Likes({super.key, required this.product});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  bool get isOn => widget.product.likers.contains(AuthService().uid);
  late bool state;
  @override
  void initState() {
    super.initState();
    state = isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.product.likers.length.annotate()),
        ),
        IconButton(
            onPressed: () {
              if (AuthService().isSignedIn) {
                if (state) {
                  FireStoreService().unlikeProduct(widget.product.globalId);
                  widget.product.likers.remove(AuthService().uid!);
                } else {
                  FireStoreService().likeProduct(widget.product.globalId);
                  widget.product.likers.add(AuthService().uid!);
                }
                setState(() {
                  state = !state;
                });
              } else {
                alert(context,
                    "الرجاء تسجيل الدخول للتمكن من حفظ والاعجاب بالمعروضات");
              }
            },
            icon: state
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  )),
      ],
    );
  }
}

class Bookmark extends StatefulWidget {
  final ProductInfo product;
  const Bookmark({super.key, required this.product});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  bool get isOn => widget.product.bookmarkers.contains(AuthService().uid);
  late bool state;
  @override
  void initState() {
    super.initState();
    state = isOn;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (AuthService().isSignedIn) {
            state = !state;
            if (state) {
              FireStoreService().addToSaved(widget.product.globalId);
              widget.product.bookmarkers.add(AuthService().uid!);
            } else {
              FireStoreService().removeFromSaved(widget.product.globalId);
              widget.product.bookmarkers.remove(AuthService().uid!);
            }
            setState(() {});
          } else {
            alert(context,
                "الرجاء تسجيل الدخول للتمكن من حفظ والاعجاب بالمعروضات");
          }
        },
        icon: isOn
            ? const Icon(
                Icons.bookmark,
                color: Colors.yellow,
              )
            : const Icon(
                Icons.bookmark_add_outlined,
                color: Colors.grey,
              ));
  }
}
