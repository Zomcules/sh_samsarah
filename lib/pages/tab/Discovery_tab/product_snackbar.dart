import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/auth_flow/profile_photo.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/location_preview.dart';
import 'package:samsarah/util/tools/my_text.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/models/product_info.dart';
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
    String getTimeStamp(Timestamp timeStamp) {
      final date = timeStamp.toDate();
      final diff = DateTime.now().difference(date);
      // if less than hour gives -1
      if (diff.compareTo(const Duration(hours: 1)) <= 0) {
        return "الان";
      }
      if (diff.compareTo(const Duration(days: 1)) <= 0) {
        return "اليوم";
      }
      if (diff.compareTo(const Duration(days: 6)) <= 0) {
        return "منذ ${diff.inDays.toString()} أيام";
      }
      if (diff.compareTo(const Duration(days: 8)) <= 0) {
        return "منذ أسبوع";
      }
      return date.toString();
    }

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
              ////////////// top row //////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: product.producer["globalId"] != AuthService().uid
                        ? Row(
                            children: [
                              ProfilePhoto(
                                username: product.producer["username"],
                                radius: 12,
                                imagePath: product.producer["imagePath"],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(product.producer["username"]),
                              ),
                            ],
                          )
                        : const Text(
                            "أنت",
                            style: TextStyle(color: Colors.green, fontSize: 24),
                          ),
                  ),
                  //price
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
                          product.price.annotate(),
                          style: TextStyle(
                              color: Colors.black.withOpacity(.6),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    child: Wrap(
                        //alignment: WrapAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: getAttributes(product)),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getTimeStamp(product.timeStamp),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: [
                      Bookmark(product: product),
                      Likes(product: product)
                    ],
                  )
                ],
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
  final auth = AuthService();
  final store = Database();
  String? get uid => auth.uid;
  bool get isOn => widget.product.likers.contains(uid);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.product.likers.length.annotate()),
        ),
        IconButton(
            onPressed: () async {
              if (auth.isSignedIn) {
                if (isOn) {
                  await store.unlikeProduct(widget.product.globalId);
                  widget.product.likers.remove(uid!);
                } else {
                  await store.likeProduct(widget.product.globalId);
                  widget.product.likers.add(uid!);
                }
                setState(() {});
              } else {
                alert(context,
                    "الرجاء تسجيل الدخول للتمكن من حفظ والاعجاب بالمعروضات");
              }
            },
            icon: isOn
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
  final auth = AuthService();
  final store = Database();
  String? get uid => auth.uid;
  bool get isOn => widget.product.bookmarkers.contains(uid);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (auth.isSignedIn) {
            if (isOn) {
              await store.removeFromSaved(widget.product.globalId);
              widget.product.bookmarkers.remove(uid!);
            } else {
              await store.addToSaved(widget.product.globalId);
              widget.product.bookmarkers.add(uid!);
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
