import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/models/prices_model.dart';
import 'package:samsarah/pages/tab/chat_app/profile.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/models/account_info.dart';
import 'package:samsarah/util/database/fetchers.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/models/product_info.dart';
import '../../pages/tab/auth_flow/activate_voucher.dart';
import '../../pages/tab/chat_app/chat_page/chat_page.dart';
import '../tools/my_button.dart';
import '../tools/my_text_form_field.dart';
import '../tools/poppers_and_pushers.dart';
import 'product_preview_page/fields/location_preview.dart';
import 'product_preview_page/fields/more_button.dart';
import 'product_preview_page/fields/my_check_box.dart';
import 'product_preview_page/fields/ppp_floating_button.dart';
import 'product_preview_page/fields/two_choices.dart';
import 'product_preview_page/fields/zone_field.dart';

class ProductPreviewPage extends StatefulWidget {
  final PPPType type;
  final ProductInfo? info;
  final GeoPoint? geoPoint;
  const ProductPreviewPage(
      {super.key, this.info, required this.type, this.geoPoint})
      : assert(type != PPPType.viewExternal || info != null),
        assert(type != PPPType.viewInternal || info != null);

  @override
  State<ProductPreviewPage> createState() => _ProductPreviewPageState();
}

class _ProductPreviewPageState extends State<ProductPreviewPage> {
  @override
  void initState() {
    super.initState();
    if (widget.type != PPPType.viewExternal) {
      producer = _auth.currentAccount;
    } else {
      producer = fetchAccount(widget.info!.producer["globalId"]);
    }
    pc.geopoint = widget.geoPoint;
  }

  late Future<AccountInfo?> producer;
  final _auth = AuthService();
  final _msg = ChatService();
  final pc = ProductController();
  final formKey = GlobalKey<FormState>();
  bool showMore = false;

  Widget title() {
    switch (widget.type) {
      case PPPType.createNew:
        return const Text("انشاء عرض جديد");
      case PPPType.viewExternal:
        return widget.info!.producer["globalId"] == _auth.uid
            ? const Text(
                "أنت",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 146, 5)),
              )
            : GestureDetector(
                onTap: () => push(
                    context,
                    ProfilePage(
                      id: widget.info!.producer["globalId"],
                    )),
                child: Text(widget.info!.producer["username"]));
      case PPPType.viewInternal:
        return const Text("تعديل العرض");
      default:
        return const Placeholder();
    }
  }

  void messageProducer(String uid) async {
    if (_auth.isSignedIn) {
      if (uid != _auth.uid) {
        await _msg.initiateNewChat(uid);
        if (mounted) {
          push(
            context,
            ChatPage(
                reciever: await store.getAccount(uid),
                appendedProduct: widget.info),
          );
        }
      }
    } else {
      alert(context, "سجل الدخول في التطبيق لتتمكن من مراسلة المستخدمين");
    }
  }

  void saveEditing() {}

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await tryPublishProduct(pc.getProduct());
    } else {
      alert(context, "بعض الحقول فارغة");
    }
  }

  Future<void> tryPublishProduct(ProductInfo product) async {
    Future<PricesModel> getFuture() {
      return store.getPrices();
    }

    Future<PricesModel> future = getFuture();

    if (context.mounted) {
      bool? result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("نشر العرض"),
                content: FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("خطأ في الشبكة");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          Text(
                            "${snapshot.data!.currency.toString()} :رصيدك الان",
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(
                            "سعر النشر: ${snapshot.data!.publishPrice.toString()}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          snapshot.data!.publishPrice <= snapshot.data!.currency
                              ? const Text(
                                  "هل تريد عرض منتجك على التطبيق؟",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.green),
                                )
                              : const Text(
                                  "نأسف ولكن يبدون ان ليس لديك رصيد كافي",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                )
                        ],
                      );
                    }),
                actions: [
                  FutureBuilder(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        if (snapshot.hasError) {
                          return const SizedBox();
                        }
                        return snapshot.data!.publishPrice <=
                                snapshot.data!.currency
                            ? MyButton(
                                onPressed: () {
                                  pop(context, true);
                                  store.saveProduct(product);
                                  store.updateCurrency(
                                      0 - snapshot.data!.publishPrice);
                                },
                                raised: true,
                                title: "موافق")
                            : MyButton(
                                onPressed: () =>
                                    push(context, const ActivateVoucherPage()),
                                raised: true,
                                title: "شحن رصيد");
                      }),
                  MyButton(
                      onPressed: () => pop(context, false),
                      raised: false,
                      title: "الرجوع")
                ],
              ));
      if (result != null) {
        if (result) {
          if (mounted) pop(context);
        }
      }
    }
  }

  List<Widget> get fields {
    var temp = [
      const SizedBox(
        height: 50,
      ),
      LocationPreview(
        pc: pc,
        geopoint: widget.info?.geopoint,
        type: widget.type,
        validator: (geoPoint) => geoPoint != null ? null : "Null GeoPoint",
      ),
      TwoChoices(
          type: widget.type,
          pc: pc,
          tcType: TwoChoicesType.saleRent,
          productInfo: widget.info),
      MyTextFormField(
        pppType: widget.type,
        onSaved: (value) => pc.price = int.parse(value!),
        validator: validateForInt,
        keyboardType: TextInputType.number,
        labelText: "السعر",
        initialValue: widget.info?.price.toString(),
      ),
      MoreButton(onPressed: onMorePressed),
      const SizedBox(
        height: 300,
      )
    ];
    if (showMore) {
      temp.insertAll(temp.length - 2, [
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.services,
            product: widget.info,
            controller: pc),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.certified,
            product: widget.info,
            controller: pc),
        MyTextFormField(
          pppType: widget.type,
          onSaved: (value) => pc.size = int.parse(value!),
          validator: validateForInt,
          keyboardType: TextInputType.number,
          labelText: "المساحة",
          initialValue: widget.info?.size.toString(),
        ),
        ZoneField(
          type: widget.type,
          pc: pc,
          info: widget.info,
        )
      ]);
    }
    return temp;
  }

  void onMorePressed() {
    setState(() {
      showMore = !showMore;
    });
  }

  onPressed() async {
    switch (widget.type) {
      case PPPType.createNew:
        await saveProduct();
        break;
      case PPPType.viewExternal:
        messageProducer(widget.info!.producer["globalId"]);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: title()),
        body: Form(
            key: formKey,
            child: ListView.separated(
              addAutomaticKeepAlives: true,
              itemCount: fields.length,
              itemBuilder: (context, index) => fields[index],
              separatorBuilder: (context, index) => const SizedBox(
                height: 50,
              ),
            )),
        floatingActionButton: ProductPreviewFloatinButton(
            type: widget.type, onPressed: onPressed));
  }
}
