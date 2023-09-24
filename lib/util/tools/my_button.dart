import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final bool raised;
  const MyButton(
      {super.key,
      required this.onPressed,
      required this.raised,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: raised ? Colors.blue : null,
            border: !raised ? Border.all() : null),
        child: Text(
          title,
          style: TextStyle(
              color: raised ? Colors.white : null, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
