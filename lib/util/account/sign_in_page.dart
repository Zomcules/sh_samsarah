import 'dart:math';

import 'package:flutter/material.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/database.dart';

import '../tools/poppers_and_pushers.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final db = DataBase();
  final myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل الدخول")),
      body: Form(
          key: myKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      labelText: "اسم المستخدم",
                    ),
                    onSaved: (newValue) {
                      buildUserAccount(newValue!);
                      pop(context, true);
                    },
                    autovalidateMode: AutovalidateMode.always,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "الحقل لا يمكن ان يكون فارغا";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => myKey.currentState!.save(),
                  child: const Text("نسجيل الان"))
            ],
          )),
    );
  }

  buildUserAccount(String newValue) async {
    db.changeActiveAccount(
        info: AccountInfo(
            username: newValue,
            globalId: Random().nextInt(9999).toString(),
            productIds: []));
  }
}
