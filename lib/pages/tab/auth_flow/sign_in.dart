import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/error_handler.dart';
import 'package:samsarah/pages/tab/auth_flow/my_profile_page.dart';
import 'package:samsarah/models/account_info.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
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
  final auth = AuthService().instance;
  final emailControl = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  final usernameController = TextEditingController();
  bool createNew = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تسجيل الدخول"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children),
      ),
    );
  }

  void trySignIn() async {
    key.currentState!.save();
    try {
      await auth.signInWithEmailAndPassword(
          email: emailControl.text, password: passwordController.text);
      if (mounted) {
        pushReplacement(context, const MyProfilePage());
      }
    } on FirebaseAuthException catch (e) {
      await alert(context, handleError(e));
      setState(() {
        isLoading = false;
      });
    }
  }

  void tryCreateAccount() async {
    setState(() {
      isLoading = true;
    });
    if (passwordController.text == password2Controller.text) {
      try {
        await auth.createUserWithEmailAndPassword(
            email: emailControl.text, password: passwordController.text);
        await auth.currentUser!.updateDisplayName(usernameController.text);
        await Database().accountCollection.doc(auth.currentUser!.uid).set(
              AccountInfo(
                username: usernameController.text,
                globalId: auth.currentUser!.uid,
                currency: 0,
              ),
            );
      } on FirebaseAuthException catch (e) {
        await alert(context, handleError(e));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      await alert(context, "كلمة السر غير متطابقة");
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  String? validator(String? value) =>
      value == "" || value == null ? "هذا الحقل فارغ" : null;

  List<Widget> get children {
    if (createNew) {
      return [
        Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextFormField(
                        controller: usernameController,
                        onSaved: (_) {},
                        validator: validator,
                        keyboardType: TextInputType.name,
                        labelText: "الاسم",
                        pppType: PPPType.createNew),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextFormField(
                        controller: emailControl,
                        onSaved: (value) {},
                        validator: validator,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "البريد الالكتروني",
                        pppType: PPPType.createNew),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextFormField(
                        controller: passwordController,
                        onSaved: (value) {},
                        validator: validator,
                        keyboardType: TextInputType.name,
                        labelText: "كلمة السر",
                        pppType: PPPType.createNew),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextFormField(
                        controller: password2Controller,
                        onSaved: (value) => password2Controller.text = value!,
                        validator: (value) => passwordController.text == value
                            ? null
                            : "كلمة السر غير متطابقة",
                        keyboardType: TextInputType.name,
                        labelText: "أعد كتابة كلمة السر",
                        pppType: PPPType.createNew),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
              !isLoading
                  ? MyButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        tryCreateAccount();
                      },
                      raised: true,
                      title: "انشاء الحساب")
                  : const CircularProgressIndicator(),
            ],
          ),
        )
      ];
    }
    return [
      Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextFormField(
                    controller: emailControl,
                    onSaved: (value) {},
                    validator: validator,
                    keyboardType: TextInputType.emailAddress,
                    labelText: "عنوان البريد الالكتروني",
                    pppType: PPPType.createNew),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextFormField(
                    controller: passwordController,
                    onSaved: (value) {},
                    validator: validator,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: "كلمة السر",
                    pppType: PPPType.createNew),
              ),
            ],
          ),
        ],
      ),
      GestureDetector(
        onTap: () async {
          try {
            await AuthService().signInWithGoogle();
          } catch (e) {
            debugPrint("google failed");
          }
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "G",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "تسجيل الدخول باستخدام جوجل",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyButton(
                onPressed: () => setState(() {
                      createNew = true;
                    }),
                raised: false,
                title: "انشاء حساب جديد"),
            !isLoading
                ? MyButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      trySignIn();
                    },
                    raised: true,
                    title: "تسجيل الدخول")
                : const CircularProgressIndicator(),
          ],
        ),
      )
    ];
  }
}
