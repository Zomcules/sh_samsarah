import 'package:flutter/material.dart';

Future<R?> push<R>(BuildContext context, Widget page) async {
  return await Navigator.push(
    context,
    MaterialPageRoute<R>(
      builder: (context) => page,
    ),
  );
}

Future<void> pushReplacement(BuildContext context, Widget page) async {
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

pop(BuildContext context, dynamic result) {
  Navigator.pop(context, result);
}

Future<void> alert(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(
        message,
        textDirection: TextDirection.rtl,
      ),
    ),
  );
}

Future<void> alertWidget(BuildContext context, Widget widget) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: widget,
    ),
  );
}
