import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';

import '../../../util/tools/get_image.dart';
import '../../../util/tools/poppers_and_pushers.dart';

class ChatHeader extends StatelessWidget {
  final String reciever;
  const ChatHeader({super.key, required this.reciever});
  FireStoreService get store => FireStoreService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: store.accountStreamOf(reciever),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var acc = snapshot.data!.data()!;
            return AppBar(
              automaticallyImplyLeading: false,
              actions: const [
                IconButton(onPressed: null, icon: Icon(Icons.more_vert))
              ],
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
                          GetImage(
                            imagePath: acc.imagePath ?? "",
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(acc.username),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
