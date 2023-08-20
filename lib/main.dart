import 'package:flutter/material.dart';
import 'package:samsarah/tab/home_page.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/internet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DataBase().init();

  await Internet().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      title: "Samsarah",
      // theme: ThemeData(
      //   primaryColor: Colors.white,
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
