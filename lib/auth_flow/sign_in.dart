import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/modules/account_info.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/my_text_form_field.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final key = GlobalKey<FormState>();
  final auth = AuthService().firebaseAuth;
  late String email;
  late String password;
  late String password2;
  late String username;
  bool createNew = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تسجيل الدخول"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: !createNew
              ? [
                  MyTextFormField(
                      onSaved: (value) => email = value!,
                      validator: validator,
                      keyboardType: TextInputType.emailAddress,
                      labelText: "عنوان البريد الالكتروني",
                      pppType: PPPType.createNew),
                  MyTextFormField(
                      onSaved: (value) => password = value!,
                      validator: validator,
                      keyboardType: TextInputType.visiblePassword,
                      labelText: "كلمة السر",
                      pppType: PPPType.createNew),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                          onPressed: () => setState(() {
                                createNew = true;
                              }),
                          raised: false,
                          title: "انشاء حساب جديد"),
                      MyButton(
                          onPressed: trySignIn,
                          raised: true,
                          title: "تسجيل الدخول"),
                    ],
                  )
                ]
              : [
                  MyTextFormField(
                      onSaved: (value) => username = value!,
                      validator: validator,
                      keyboardType: TextInputType.name,
                      labelText: "الاسم",
                      pppType: PPPType.createNew),
                  MyTextFormField(
                      onSaved: (value) => email = value!,
                      validator: validator,
                      keyboardType: TextInputType.emailAddress,
                      labelText: "البريد الالكتروني",
                      pppType: PPPType.createNew),
                  MyTextFormField(
                      onSaved: (value) => password = value!,
                      validator: validator,
                      keyboardType: TextInputType.name,
                      labelText: "كلمة السر",
                      pppType: PPPType.createNew),
                  MyTextFormField(
                      onSaved: (value) => password2 = value!,
                      validator: validator,
                      keyboardType: TextInputType.name,
                      labelText: "أعد كتابة كلمة السر",
                      pppType: PPPType.createNew),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                          onPressed: () {
                            setState(() {
                              createNew = false;
                            });
                          },
                          raised: false,
                          title: "رجوع"),
                      MyButton(
                          onPressed: tryCreateAccount,
                          raised: true,
                          title: "انشاء الحساب"),
                    ],
                  )
                ],
        ),
      ),
    );
  }

  void trySignIn() async {
    key.currentState!.save();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (mounted) {
        pop(context, null);
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.code),
        ),
      );
    }
  }

  void tryCreateAccount() async {
    key.currentState!.save();
    if (password == password2) {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await auth.currentUser!.updateDisplayName(username);
        await FireStoreService()
            .accountCollection
            .doc(auth.currentUser!.uid)
            .set(AccountInfo(
                username: username,
                globalId: auth.currentUser!.uid,
                currency: 0,
                savedProducts: []));
        if (mounted) {
          pop(context, null);
        }
      } on FirebaseAuthException catch (e) {
        alert(context, e.code);
      }
    } else {
      alert(context, "كلمة السر غير متطابقة");
    }
  }

  String? validator(String? value) {
    return value == "" || value == null ? "هذا الحقل فارغ" : null;
  }
}
