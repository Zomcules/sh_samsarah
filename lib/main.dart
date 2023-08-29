import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/tab/home_page.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/internet.dart';
import 'package:samsarah/util/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await DataBase().init();

  runApp(const MyApp());
}

var net = Net();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Samsarah",
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      routes: {
        "/sign-in": (context) => SignInScreen(
              providers: [EmailAuthProvider()],
              actions: [
                AuthStateChangeAction<SignedIn>(
                  (context, state) async {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, "/profile");
                    }
                    var account = (await net.currentAccount);
                    await net.accountCollection
                        .doc(account!.globalId)
                        .set(account);
                    await DataBase().openAccountSpecificBoxes();
                  },
                )
              ],
            ),
        "/profile": (context) => MyProfile(providers: [
              EmailAuthProvider()
            ], actions: [
              SignedOutAction(
                (context) {
                  Navigator.pushReplacementNamed(context, "/sign-in");
                },
              )
            ])
      },
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
