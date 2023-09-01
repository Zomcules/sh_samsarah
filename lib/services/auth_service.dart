import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samsarah/services/firestore_service.dart';

import '../modules/account_info.dart';
import '../modules/chat_room.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final _store = FireStoreService();

  String? get uid => auth.currentUser?.uid;

  bool get isSignedIn => auth.currentUser != null;

  Future<AccountInfo?> get currentAccount async {
    if (auth.currentUser != null) {
      var list = await _store.getProductsOf(uid!);
      var rooms = await chatRoomsOfUser();
      return AccountInfo(
          username: auth.currentUser?.displayName ?? "",
          globalId: auth.currentUser!.uid,
          productIds:
              List.generate(list.length, (index) => list[index].globalId),
          currency: await getCurrency(),
          savedProducts: await _store.savedProductsIdsOf(uid!),
          chatRooms:
              List<String>.generate(rooms.length, (index) => rooms[index].id));
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

  Future<List<QueryDocumentSnapshot<ChatRoom>>> chatRoomsOfUser() async {
    return (await _store.instance
            .collection("ChatRooms")
            .withConverter<ChatRoom>(
              fromFirestore: (snapshot, options) =>
                  ChatRoom.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap(),
            )
            .where("chatters", arrayContains: AuthService().uid)
            .get())
        .docs;
  }
}
