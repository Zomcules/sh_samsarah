import 'package:flutter/material.dart';

Future<R?> push<R>(BuildContext context, Widget page) async {
  return (await Navigator.push(
      context,
      MaterialPageRoute<R>(
        builder: (context) => page,
      )));
}

pop(BuildContext context, dynamic result) {
  Navigator.pop(context, result);
}
