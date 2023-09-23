import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/util/tools/extensions.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final auth = AuthService().firebaseAuth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(auth.currentUser!.displayName ?? "No Data"),
        actions: [
          IconButton(
              onPressed: () => auth.signOut(),
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(getInitials()),
          ),
        ],
      ),
    );
  }

  String getInitials() => auth.currentUser!.displayName!
      .split(" ")
      .translate((element) => element[0])
      .join(" ");
}
