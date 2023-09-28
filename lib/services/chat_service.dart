import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/modules/message_data.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';

class ChatService {
  final _store = Database();
  final _auth = AuthService();

  String _chatRoomIdOf(String uid) {
    var list = [AuthService().uid!, uid];
    list.sort();
    return list.join("-");
  }

  Future<String> initiateNewChat(String uid) async {
    String chatRoomId = _chatRoomIdOf(uid);
    var chatRoom =
        FirebaseFirestore.instance.collection("ChatRooms").doc(chatRoomId);
    await chatRoom.set({
      "chatters": [uid, _auth.uid],
      "timeStamp": Timestamp.now(),
    });
    await _store.accountCollection.doc(_auth.uid).update({
      "chatRooms": FieldValue.arrayUnion([chatRoomId])
    });
    await _store.accountCollection.doc(uid).update({
      "chatRooms": FieldValue.arrayUnion([chatRoomId])
    });
    return chatRoom.id;
  }

  Stream<QuerySnapshot<MessageData>> messagesStreamOf(String uid) =>
      _store.instance
          .collection("ChatRooms")
          .doc(_chatRoomIdOf(uid))
          .collection("Messages")
          .orderBy("timeStamp", descending: true)
          .withConverter<MessageData>(
            fromFirestore: (snapshot, options) =>
                MessageData.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get userChatRooms =>
      _store.instance
          .collection("ChatRooms")
          .where("chatters", arrayContains: _auth.uid)
          .orderBy("timeStamp")
          .snapshots();

  Future<bool> sendMessage(MessageData message, String reciever) async {
    try {
      var doc =
          _store.instance.collection("ChatRooms").doc(_chatRoomIdOf(reciever));
      await doc
          .collection("Messages")
          .add(message.toMap())
          .onError((error, stackTrace) => throw Error());
      await doc.update({"timeStamp": Timestamp.now()}).onError(
          (error, stackTrace) => throw Error());
      return true;
    } catch (e) {
      return false;
    }
  }
}
