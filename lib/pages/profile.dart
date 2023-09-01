import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/modules/account_info.dart';

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
    future = auth.currentAccount;
  }

  final auth = AuthService();
  final store = FireStoreService();

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
          child: StreamBuilder(
            stream: store.accountCollection.doc(auth.uid).snapshots(),
            builder: (context, snapshot) => snapshot.hasData
                ? Text(snapshot.data!.data()?.toMap().toString() ?? "")
                : const CircularProgressIndicator(),
          ),
        )
      ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        auth.syncUser();
        return Future.value(true);
      },
      child: ListView(
        children: children,
      ),
    );
  }
}
