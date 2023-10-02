import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/my_profile_page.dart';
import 'package:samsarah/pages/tab/auth_flow/sign_in.dart';
import 'package:samsarah/services/auth_service.dart';

class AuthController extends StatelessWidget {
  const AuthController({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return StreamBuilder(
        stream: auth.instance.authStateChanges(),
        builder: (context, snapshot) =>
            auth.isSignedIn ? const MyProfilePage() : const SignInPage());
  }
}
