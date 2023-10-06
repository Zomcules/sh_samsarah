import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/auth_controller.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/pages/tab/drawer.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';
import 'chat_app/messages_page.dart';
import 'tabs/Discovery_tab/discovery_tab.dart';
import 'tabs/Feed_tab/feed_tab.dart';
import 'tabs/map_tab/map_tab.dart';

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
    const Tab(child: Icon(Icons.newspaper)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white
        actions: [
          StreamBuilder(
            stream: auth.instance.userChanges(),
            builder: (context, snapshot) {
              return IconButton(
                onPressed: snapshot.data != null
                    ? () {
                        push(
                          context,
                          const MessagesPage(),
                        );
                      }
                    : null,
                icon: const Icon(Icons.message),
              );
            },
          ),
          StreamBuilder(
            stream: auth.instance.userChanges(),
            builder: (context, snapshot) {
              return IconButton(
                onPressed: () {
                  push(context, const AuthController());
                },
                icon: snapshot.hasData
                    ? const UserThumbnail()
                    : const Icon(Icons.person),
              );
            },
          ),
        ],
        title: const Text("Samsarah",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
                  FeedTab(),
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
        ),
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
      stream: auth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfilePhoto(
            imagePath: snapshot.data!.photoURL ?? "",
            radius: 20,
            username: snapshot.data!.displayName,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
