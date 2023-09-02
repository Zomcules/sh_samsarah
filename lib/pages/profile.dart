import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class MyProfile extends StatefulWidget {
  final List<AuthProvider<AuthListener, AuthCredential>>? providers;
  final List<FirebaseUIAction>? actions;
  const MyProfile({super.key, this.providers, this.actions});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
        ElevatedButton(
            onPressed: () => push(context, const AccData()),
            child: const Text("DEBUG"))
      ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AuthService().syncUser();
        return Future.value(true);
      },
      child: ListView(
        children: children,
      ),
    );
  }
}

class AccData extends StatelessWidget {
  AuthService get auth => AuthService();
  FireStoreService get store => FireStoreService();
  const AccData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: store.accountCollection.doc(auth.uid).snapshots(),
        builder: (context, snapshot) => snapshot.hasData
            ? Container(
                color: Colors.white,
                child: Center(
                    child:
                        Text(snapshot.data!.data()?.toMap().toString() ?? "")))
            : const CircularProgressIndicator(),
      ),
    );
  }
}
