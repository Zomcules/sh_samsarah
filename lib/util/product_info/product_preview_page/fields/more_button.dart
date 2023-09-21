import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  const MoreButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "خيارات اضافية",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_downward_rounded,
                    size: 16,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
