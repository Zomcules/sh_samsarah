import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_fields/more_button.dart';
import 'package:samsarah/util/product_info/product_fields/my_check_box.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/fetchers.dart';
import 'package:samsarah/util/product_info/product_fields/controller.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_fields/two_choices.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import '../../chat_app/chat_page/chat_page.dart';
import 'product_fields/location_preview.dart';
import 'product_fields/zone_field.dart';
import '../tools/my_text_form_field.dart';

class ProductPreviewPage extends StatefulWidget {
  final PPPType type;
  final ProductInfo? info;
  const ProductPreviewPage({super.key, this.info, required this.type})
      : assert(type != PPPType.viewExternal || info != null),
        assert(type != PPPType.viewInternal || info != null);

  @override
  State<ProductPreviewPage> createState() => _ProductPreviewPageState();
}

class _ProductPreviewPageState extends State<ProductPreviewPage> {
  @override
  void initState() {
    super.initState();
    producer = fetchAccount(widget.info?.accountInfoGlobalId ?? "")
        as Future<AccountInfo>;
  }

  late Future<AccountInfo> producer;
  final db = DataBase();
  final pc = ProductController();
  final formKey = GlobalKey<FormState>();
  bool showMore = false;

  Widget title(AsyncSnapshot<AccountInfo> snapshot) {
    switch (widget.type) {
      case PPPType.createNew:
        return const Text("انشاء عرض جديد");
      case PPPType.search:
        return const Text("البحث عن عرض");
      case PPPType.viewExternal:
        return snapshot.connectionState == ConnectionState.done
            ? Text(snapshot.data!.username)
            : const CircularProgressIndicator();
      case PPPType.viewInternal:
        return const Text("تعديل العرض");
      default:
        return const Text("");
    }
  }

  void messageProducer(AccountInfo info) async {
    if (db.activeBox.isNotEmpty) {
      if (!info.isInBox) {
        await db.accountInfos.add(info);
      }
      await db.openMessages();
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatPage(reciever: info, appendedProduct: widget.info),
            ));
      }
    }
  }

  void saveEditing() {
    widget.info!.save();
  }

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await pc.save();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("Success"),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Unimplemented Fields!"),
        ),
      );
    }
  }

  void searchProduct() {
    pc.getSearchFieldsMap();
  }

  List<Widget> getFields() {
    var temp = [
      const SizedBox(
        height: 50,
      ),
      LocationPreview(
          pc: pc, geopoint: widget.info?.geopoint, type: widget.type),
      TwoChoices(
          type: widget.type,
          pc: pc,
          tcType: TwoChoicesType.saleRent,
          productInfo: widget.info),
      MyTextFormField(
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

  onPressed(AsyncSnapshot<AccountInfo> snapshot) async {
    switch (widget.type) {
      case PPPType.createNew:
        await saveProduct();
        break;
      case PPPType.search:
        searchProduct();
        break;
      case PPPType.viewExternal:
        snapshot.connectionState == ConnectionState.done
            ? messageProducer(snapshot.data!)
            : null;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: producer,
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(title: title(snapshot)),
            body: Form(
                key: formKey,
                child: ListView.separated(
                  addAutomaticKeepAlives: true,
                  itemCount: getFields().length,
                  itemBuilder: (context, index) => getFields()[index],
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 50,
                  ),
                )),
            floatingActionButton: ProductPreviewFloatinButton(
                type: widget.type, onPressed: () => onPressed(snapshot)));
      },
    );
  }
}
