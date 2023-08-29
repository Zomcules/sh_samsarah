import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/test/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: TestHome(),
    ),
  );
}
