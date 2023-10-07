import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/models/account_info.dart';
import 'package:samsarah/services/database_service.dart';
import '../../../../../util/tools/poppers_and_pushers.dart';

class ChatHeader extends StatelessWidget {
  final AccountInfo reciever;
  const ChatHeader({super.key, required this.reciever});
  Database get store => Database();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      centerTitle: false,
      titleSpacing: 0,
      title:
          //  Text(controller.appendedProducts.toString()),
          Row(
        children: [
          GestureDetector(
            onTap: () => pop(context, null),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  ProfilePhoto(
                    imagePath: reciever.imagePath ?? "",
                    radius: 20,
                    username: reciever.username,
                  )
                ],
              ),
            ),
          ),
          Text(reciever.username),
        ],
      ),
    );
  }
}
