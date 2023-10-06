import 'package:flutter/material.dart';

import '../product_info/product_preview_page/fields/ppp_floating_button.dart';

class MyTextFormField extends StatefulWidget {
  final PPPType pppType;
  final String? initialValue;
  final void Function(String? value) onSaved;
  final void Function(String? value)? onChanged;
  final String? Function(String? value) validator;
  final TextInputType keyboardType;
  final String labelText;
  final TextEditingController? controller;

  const MyTextFormField(
      {super.key,
      this.onChanged,
      required this.onSaved,
      required this.validator,
      required this.keyboardType,
      required this.labelText,
      this.initialValue,
      required this.pppType,
      this.controller});

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        onChanged: widget.onChanged,
        enabled: widget.pppType != PPPType.viewExternal,
        initialValue: widget.initialValue,
        keyboardType: widget.keyboardType,
        //textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: widget.labelText,
        ),
        onSaved: widget.onSaved,
        autovalidateMode: AutovalidateMode.always,
        validator: widget.validator,
        controller: widget.controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

String? validateForInt(String? value) {
  try {
    int.parse(value ?? "0");
  } catch (e) {
    return "القيمة يجب ان تكون رقما صحيحا";
  }
  return null;
}

String? validateIntNullable(String? value) {
  if (value != null && value != "") {
    try {
      int.parse(value);
    } catch (e) {
      return "القيمة يجب ان تكون رقما صحيحا";
    }
  }
  return null;
}
