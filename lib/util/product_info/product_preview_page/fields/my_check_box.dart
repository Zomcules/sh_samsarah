import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import '../controller.dart';
import 'ppp_floating_button.dart';

class MyCheckbox extends StatefulWidget {
  final PPPType type;
  final CheckboxType cType;
  final ProductInfo? product;
  final ProductController controller;

  const MyCheckbox(
      {super.key,
      required this.type,
      required this.cType,
      this.product,
      required this.controller});

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox>
    with AutomaticKeepAliveClientMixin {
  late final _Data data;

  late bool state;

  @override
  void initState() {
    super.initState();
    data = _Data.fromType(
        widget.cType, widget.type, widget.product, widget.controller);
    state = data.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CheckboxListTile(
      value: state,
      enabled: data.editable, //
      onChanged: (value) => setState(() {
        state = value!;
        data.onSaved(value);
      }),
      title: Text(data.title),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Data {
  final bool editable;
  final String title;
  final bool initialValue;
  final Function(bool value) onSaved;

  _Data(
      {required this.onSaved,
      required this.editable,
      required this.title,
      required this.initialValue});
  factory _Data.fromType(CheckboxType type, PPPType pppType, ProductInfo? info,
      ProductController controller) {
    switch (type) {
      case CheckboxType.built:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "مبني",
            initialValue: (info?.built ?? controller.built) ?? true,
            onSaved: (bool value) {
              controller.built = value;
            });
      case CheckboxType.groundFloor:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "طابق أرضي",
            initialValue: (info?.groundFloor ?? controller.groundFloor) ?? true,
            onSaved: (bool value) {
              controller.groundFloor = value;
            });

      case CheckboxType.certified:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "شهادات متوفرة",
            initialValue: (info?.certified ?? controller.certified) ?? true,
            onSaved: (bool value) {
              controller.certified = value;
            });
      case CheckboxType.nasiah:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "ناصية",
            initialValue: (info?.nasiah ?? controller.nasiah) ?? false,
            onSaved: (bool value) {
              controller.nasiah = value;
            });
      case CheckboxType.services:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "خدمات",
            initialValue: (info?.services ?? controller.services) ?? true,
            onSaved: (bool value) {
              controller.services = value;
            });
      case CheckboxType.withFurniture:
        return _Data(
            editable: pppType != PPPType.viewExternal,
            title: "مفروش",
            initialValue:
                (info?.withFurniture ?? controller.withFurniture) ?? false,
            onSaved: (bool value) {
              controller.withFurniture = value;
            });
    }
  }
}

enum CheckboxType {
  services,
  certified,
  built,
  nasiah,
  groundFloor,
  withFurniture
}
