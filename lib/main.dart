import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/home_page.dart';
import 'package:samsarah/util/tools/uri_handler.dart';

import 'util/tools/my_button.dart';
import 'util/tools/poppers_and_pushers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final handler = UriHandler();

  @override
  void initState() {
    super.initState();
    handler.initUniLinks(context);
  }

  @override
  void dispose() {
    super.dispose();
    handler.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Samsarah",
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async =>
            await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("الخروج من التطبيق"),
                content: const Text("هل انت متأكد؟"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => pop(context, true),
                      child: const Text(
                        "نعم",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  MyButton(
                      onPressed: () => pop(context, false),
                      raised: true,
                      title: "العودة"),
                ],
              ),
            ) ??
            false,
        child: const MyHomePage(),
      ),
    );
  }
}
