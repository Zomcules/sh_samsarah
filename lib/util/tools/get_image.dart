import 'package:flutter/material.dart';

import '../database/internet.dart';

class GetImage extends StatelessWidget {
  final String imagePath;
  final int size;
  GetImage({super.key, required this.imagePath, required this.size});
  final net = Net();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: net.auth.userChanges(),
        builder: (context, snapshot) => snapshot.hasData
            ? CircleAvatar(
                radius: size / 1,
                foregroundImage: NetworkImage(snapshot.data!.photoURL ?? ""),
                child: Icon(
                  Icons.person,
                  size: size.toDouble(),
                  color: const Color.fromARGB(255, 153, 153, 153),
                ),
              )
            : const CircularProgressIndicator());
  }
}
