import 'package:flutter/material.dart';

Future<R?> push<R>(BuildContext context, Widget page) async {
  return await Navigator.push(
    context,
    MaterialPageRoute<R>(
      builder: (context) => page,
    ),
  );
}

Future<R?> pushNamed<R>(BuildContext context, String routeName) async {
  return await Navigator.pushNamed<R>(context, routeName);
}

pop(BuildContext context, dynamic result) {
  Navigator.pop(context, result);
}
