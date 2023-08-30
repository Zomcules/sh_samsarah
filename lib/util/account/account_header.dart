import 'package:flutter/material.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/internet.dart';
import 'package:samsarah/util/tools/get_image.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class AccountHeader extends StatefulWidget {
  const AccountHeader({
    super.key,
  });

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  final db = DataBase();
  final net = Net();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Net().auth.userChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GestureDetector(
                  onTap: () => pushNamed(
                    context,
                    net.isSignedIn ? "/profile" : "/sign-in",
                  ),
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GetImage(
                            imagePath: net.auth.currentUser?.photoURL ?? "",
                            size: 50),
                        Text(
                          net.auth.currentUser?.displayName ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: StreamBuilder(
                              stream: net.auth.userChanges(),
                              builder: (context, snapshot) => snapshot.hasData
                                  ? GetImage(
                                      imagePath: snapshot.data!.photoURL ?? "",
                                      size: 20)
                                  : const CircularProgressIndicator()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                )
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 0, 125, 228)),
                          child: IconButton(
                              onPressed: () => pushNamed(context,
                                  net.isSignedIn ? "/profile" : "/sign-in"),
                              icon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        )
                      ]),
                );
        });
    ////////////////////////////////////////////////////////////
  }
}
