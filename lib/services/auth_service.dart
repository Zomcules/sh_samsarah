import 'package:firebase_auth/firebase_auth.dart';
import 'package:samsarah/services/firestore_service.dart';

import '../modules/account_info.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final _store = FireStoreService();

  String? get uid => auth.currentUser?.uid;

  bool get isSignedIn => auth.currentUser != null;

  Future<AccountInfo?> get currentAccount async {
    if (auth.currentUser != null) {
      var list = await _store.getProductsOf(uid!);
      return AccountInfo(
          username: auth.currentUser!.displayName ?? "",
          globalId: auth.currentUser!.uid,
          imagePath: auth.currentUser!.photoURL,
          productIds:
              List.generate(list.length, (index) => list[index].globalId),
          currency: await getCurrency(),
          savedProducts: await _store.savedProductsIdsOf(uid!),
          chatters: await getChatters());
    }
    return null;
  }

  Future<void> syncUser() async {
    _store.accountCollection
        .doc(auth.currentUser!.uid)
        .set((await currentAccount)!);
  }

  Future<int> getCurrency() async {
    return (await currentAccount)?.currency ?? 0;
  }

  Future<List<String>> getChatters() async {
    final acc = await _store.accountCollection.doc(auth.currentUser!.uid).get();
    return acc.data()!.chatters;
  }
}
