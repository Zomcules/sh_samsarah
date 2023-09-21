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
      var acc = AccountInfo(
        username: auth.currentUser!.displayName ?? "",
        globalId: auth.currentUser!.uid,
        imagePath: auth.currentUser!.photoURL,
        productIds: await _store.getProductIdsOf(auth.currentUser!.uid),
        currency: await getCurrency(),
        savedProducts: await _store.savedProductsIdsOf(uid!),
      );
      await _store.accountCollection.doc(auth.currentUser!.uid).set((acc));
    }
  }

  Future<int> getCurrency() async {
    return (await currentAccount)?.currency ?? 0;
  }
}
