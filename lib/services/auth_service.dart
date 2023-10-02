import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samsarah/services/database_service.dart';

import '../models/account_info.dart';

class AuthService {
  final instance = FirebaseAuth.instance;
  final _store = Database();

  String? get uid => instance.currentUser?.uid;

  bool get isSignedIn => instance.currentUser != null;

  Future<AccountInfo?> get currentAccount async {
    return (await _store.accountCollection.doc(instance.currentUser!.uid).get())
        .data();
  }

  Map<String, dynamic> get userSnapshot => {
        "username": instance.currentUser!.displayName,
        "imagePath": instance.currentUser!.photoURL,
        "globalId": uid
      };

  Future<void> syncUser() async {
    final user = instance.currentUser!;
    if (instance.currentUser != null) {
      final DocumentSnapshot<AccountInfo> acc =
          await _store.accountCollection.doc(user.uid).get();

      if (acc.exists) {
        acc.reference.update({
          "username": user.displayName,
          "imagePath": user.photoURL,
          "globalId": user.uid
        });
      } else {
        acc.reference.set(AccountInfo(
          username: instance.currentUser?.displayName ?? "No Data",
          globalId: acc.reference.id,
          currency: 0,
        ));
      }
    }
  }

  Future<int> getCurrency() async => (await currentAccount)?.currency ?? 0;

  Future<void> signInWithGoogle() async {
    try {
      final gUser = await GoogleSignIn().signIn();
      final gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: gAuth.idToken, accessToken: gAuth.accessToken);
      await instance.signInWithCredential(credential);
      await syncUser();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOut() async {
    await instance.signOut();
    await GoogleSignIn().signOut();
  }

  String? get displayName => instance.currentUser?.displayName;
  String? get photoURL => instance.currentUser?.photoURL;

  Future<void> updateName(String displayName) async {
    await instance.currentUser?.updateDisplayName(displayName);
  }

  Future<void> updatePhoto(String path) async {
    await instance.currentUser?.updatePhotoURL(path);
  }
}
