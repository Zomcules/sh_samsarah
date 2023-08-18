import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String? initialValue;
  final void Function(String? value) onSaved;
  final String? Function(String? value) validator;
  final TextInputType keyboardType;
  final String labelText;

  const MyTextFormField(
      {super.key,
      required this.onSaved,
      required this.validator,
      required this.keyboardType,
      required this.labelText,
      this.initialValue});

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
        enabled: widget.initialValue == null,
        initialValue: widget.initialValue,
        keyboardType: widget.keyboardType,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          labelText: widget.labelText,
        ),
        onSaved: widget.onSaved,
        autovalidateMode: AutovalidateMode.always,
        validator: widget.validator,
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
