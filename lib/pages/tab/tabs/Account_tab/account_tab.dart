import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/auth_controller.dart';
import 'package:samsarah/pages/tab/auth_flow/my_profile_page.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().instance.authStateChanges(),
      builder: (context, snapshot) => snapshot.hasData
          ? const MyProfilePage()
          : Center(
              child: MyButton(
                  onPressed: () => push(context, const AuthController()),
                  raised: true,
                  title: "تسجيل الدخول"),
            ),
    );
  }
}
