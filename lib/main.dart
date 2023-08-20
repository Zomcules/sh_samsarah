import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/tab/home_page.dart';
import 'package:samsarah/util/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DataBase().init();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Samsarah",
      // theme: ThemeData(
      //   primaryColor: Colors.white,
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
