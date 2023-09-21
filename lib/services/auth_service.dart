import 'package:firebase_auth/firebase_auth.dart';
import 'package:samsarah/services/firestore_service.dart';

import '../modules/account_info.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final _store = FireStoreService();

  String? get uid => auth.currentUser?.uid;

  bool get isSignedIn => auth.currentUser != null;

  Future<AccountInfo?> get currentAccount async {
    return (await _store.accountCollection.doc(auth.currentUser!.uid).get())
        .data();
  }

  Future<void> syncUser() async {
    if (auth.currentUser != null) {
      await _store.accountCollection
          .doc(auth.currentUser!.uid)
          .update({"username": auth.currentUser!.displayName});
    }
  }

  Future<int> getCurrency() async {
    return (await currentAccount)?.currency ?? 0;
  }
}
