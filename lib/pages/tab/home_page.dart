import 'package:flutter/material.dart';
import 'package:samsarah/auth_flow/profile_photo.dart';
import 'package:samsarah/auth_flow/sign_in.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/pages/tab/drawer.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../auth_flow/my_profile_page.dart';
import '../../chat_app/messages_page.dart';
import 'Discovery_tab/discovery_tab.dart';
import 'Account_tab/account_tab.dart';
import 'map_tab/map_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = AuthService();
  List<Widget> myTabs = [
    const Tab(child: Icon(Icons.search)),
    const Tab(child: Icon(Icons.map)),
    const Tab(child: Icon(Icons.person)),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("الخروج من التطبيق"),
              content: const Text("هل انت متأكد؟"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => pop(context, true),
                      child: const Text(
                        "نعم",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                MyButton(
                    onPressed: () => pop(context, false),
                    raised: true,
                    title: "العودة"),
              ],
            ),
          ) ??
          false,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white
          actions: [
            StreamBuilder(
              stream: auth.firebaseAuth.userChanges(),
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: snapshot.data != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MessagesPage();
                              },
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.message),
                );
              },
            ),
            StreamBuilder(
                stream: auth.firebaseAuth.userChanges(),
                builder: (context, snapshot) {
                  return IconButton(
                      onPressed: () {
                        if (snapshot.hasData) {
                          push(context, const MyProfilePage());
                        } else {
                          push(context, const SignInPage());
                        }
                      },
                      icon: snapshot.hasData
                          ? const UserThumbnail()
                          : const Icon(Icons.person));
                }),
          ],
          title: const Text("Samsarah",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        drawer: const MyDrawer(),
        body: DefaultTabController(
            length: myTabs.length,
            child: Column(
              children: [
                const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DiscoveryTab(),
                      MapTab(),
                      AccountTab(),
                    ],
                  ),
                ),
                TabBar(
                  tabs: myTabs,
                  isScrollable: false,
                  indicatorColor: const Color.fromARGB(255, 0, 0, 255),
                  unselectedLabelColor: Colors.grey,
                  labelColor: const Color.fromARGB(255, 0, 0, 255),
                ),
              ],
            )),
      ),
    );
  }
}

class UserThumbnail extends StatefulWidget {
  const UserThumbnail({super.key});

  @override
  State<UserThumbnail> createState() => _UserThumbnailState();
}

class _UserThumbnailState extends State<UserThumbnail> {
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.firebaseAuth.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProfilePhoto(
              imagePath: snapshot.data!.photoURL ?? "",
              radius: 20,
              username: snapshot.data!.displayName,
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
