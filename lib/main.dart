import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/pages/tab/home_page.dart';
import 'package:samsarah/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final auth = AuthService();
  final store = FireStoreService();

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
                    Navigator.pushReplacementNamed(context, "/profile");
                    auth.syncUser();
                  },
                )
              ],
            ),
        "/profile": (context) => MyProfile(
              providers: [EmailAuthProvider()],
              actions: [
                SignedOutAction(
                  (context) {
                    Navigator.pushReplacementNamed(context, "/sign-in");
                  },
                ),
                AuthStateChangeAction(
                  (context, state) => AuthService().syncUser(),
                ),
              ],
            )
      },
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
