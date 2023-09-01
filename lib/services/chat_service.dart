import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsarah/modules/message_data.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/modules/account_info.dart';

class ChatService {
  final AccountInfo reciever;
  ChatService({required this.reciever});

  String get chatRoomId {
    var list = [AuthService().uid!, reciever.globalId];
    list.sort();
    return list.join("-");
  }

  CollectionReference<MessageData> get messagesCollection =>
      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(chatRoomId)
          .collection("Messages")
          .withConverter<MessageData>(
            fromFirestore: (snapshot, options) =>
                MessageData.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          );

  Stream<QuerySnapshot<MessageData>> get messages =>
      messagesCollection.snapshots();

  Future<void> sendMessage(MessageData data) async {
    await messagesCollection.add(data);
  }
}
