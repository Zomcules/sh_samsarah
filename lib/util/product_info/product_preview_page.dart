import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/chat_service.dart';
import 'package:samsarah/modules/account_info.dart';
import 'package:samsarah/util/database/fetchers.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/modules/product_info.dart';
import '../../chat_app/chat_page/chat_page.dart';
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
            : Text(widget.info!.producer["username"]);
      case PPPType.viewInternal:
        return const Text("تعديل العرض");
      default:
        return const Placeholder();
    }
  }

  void messageProducer(String uid) async {
    if (_auth.isSignedIn && uid != _auth.uid) {
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
  }

  void saveEditing() {}

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await pc.trySaveProduct(context);
    } else {
      alert(context, "بعض الحقول فارغة");
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
