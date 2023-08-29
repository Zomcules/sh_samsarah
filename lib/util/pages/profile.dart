import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/internet.dart';

class MyProfile extends StatefulWidget {
  final List<AuthProvider<AuthListener, AuthCredential>>? providers;
  final List<FirebaseUIAction>? actions;
  const MyProfile({super.key, this.providers, this.actions});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late final Future<AccountInfo?> future;
  @override
  initState() {
    super.initState();
    future = Net().currentAccount;
  }

  List<Widget> get children => [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 4 / 5,
            child: ProfileScreen(
              providers: widget.providers,
              actions: widget.actions,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.done
                    ? Text(snapshot.data!.toMap().toString())
                    : const CircularProgressIndicator(),
          ),
        )
      ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children,
    );
  }
}
