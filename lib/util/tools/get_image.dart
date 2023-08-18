import 'dart:io';
import 'package:flutter/material.dart';
import '../account/account_info.dart';

class GetImage extends StatelessWidget {
  final AccountInfo? accountInfo;
  final int size;
  const GetImage({super.key, required this.accountInfo, required this.size});

  FileImage? getFile() {
    if (accountInfo != null) {
      if (accountInfo!.imagePath != null) {
        return FileImage(File(accountInfo!.imagePath!));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 1,
      foregroundImage: getFile(),
      child: Icon(
        Icons.person,
        size: size.toDouble(),
        color: const Color.fromARGB(255, 153, 153, 153),
      ),
    );
  }
}
