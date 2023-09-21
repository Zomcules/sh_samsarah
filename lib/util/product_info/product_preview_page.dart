import 'dart:async';

import 'package:flutter/material.dart';
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
    if (widget.type != PPPType.viewExternal) {
      producer = _auth.currentAccount;
    } else {
      producer = fetchAccount(widget.info!.producerId);
    }
  }

  late Future<AccountInfo?> producer;
  final _auth = AuthService();
  final msg = ChatService();
  final pc = ProductController();
  final formKey = GlobalKey<FormState>();
  bool showMore = false;

  Widget title(AsyncSnapshot<AccountInfo?> snapshot) {
    switch (widget.type) {
      case PPPType.createNew:
        return const Text("انشاء عرض جديد");
      case PPPType.viewExternal:
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.data!.globalId == _auth.uid
                ? const Text(
                    "أنت",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 146, 5)),
                  )
                : Text(snapshot.data!.username)
            : const CircularProgressIndicator();
      case PPPType.viewInternal:
        return const Text("تعديل العرض");
      default:
        return const Placeholder();
    }
  }

  void messageProducer(AccountInfo info) async {
    if (_auth.isSignedIn && info.globalId != _auth.uid) {
      await msg.initiateNewChat(info.globalId);
      if (mounted) {
        push(
          context,
          ChatPage(reciever: info, appendedProduct: widget.info),
        );
      }
    }
  }

  void saveEditing() {}

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

  onPressed(AsyncSnapshot<AccountInfo?> snapshot) async {
    switch (widget.type) {
      case PPPType.createNew:
        await saveProduct();
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
                  itemCount: fields.length,
                  itemBuilder: (context, index) => fields[index],
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
