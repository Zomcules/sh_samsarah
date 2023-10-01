import 'package:firebase_auth/firebase_auth.dart';
import 'package:samsarah/services/database_service.dart';

import '../models/account_info.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final _store = Database();

  String? get uid => firebaseAuth.currentUser?.uid;

  bool get isSignedIn => firebaseAuth.currentUser != null;

  Future<AccountInfo?> get currentAccount async {
    return (await _store.accountCollection
            .doc(firebaseAuth.currentUser!.uid)
            .get())
        .data();
  }

  Map<String, dynamic> get userSnapshot => {
        "username": firebaseAuth.currentUser!.displayName,
        "imagePath": firebaseAuth.currentUser!.photoURL,
        "globalId": uid
      };

  Future<void> syncUser() async {
    if (firebaseAuth.currentUser != null) {
      var acc = await _store.accountCollection
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (acc.exists) {
        acc.reference
            .update({"username": firebaseAuth.currentUser!.displayName});
      } else {
        acc.reference.set(AccountInfo(
          username: firebaseAuth.currentUser?.displayName ?? "No Data",
          globalId: acc.reference.id,
          currency: 0,
        ));
      }
    }
  }

  Future<int> getCurrency() async => (await currentAccount)?.currency ?? 0;
}
