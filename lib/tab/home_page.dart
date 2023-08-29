import 'package:flutter/material.dart';
import 'package:samsarah/tab/drawer.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/internet.dart';
import 'package:samsarah/util/tools/get_image.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../chat_app/messages_page.dart';
import '../util/database/database.dart';
import 'Discovery_tab/discovery_tab.dart';
import 'Discovery_tab/product_snackbar.dart';
import 'Account_tab/account_tab.dart';
import 'map_tab/map_tab.dart';

final net = Net();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> productSnackbars = getDummyProductSnackbars();

  List<Widget> myTabs = [
    const Tab(child: Icon(Icons.search)),
    const Tab(child: Icon(Icons.map)),
    const Tab(child: Icon(Icons.person)),
  ];

  final db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white
        actions: [
          StreamBuilder(
            stream: net.auth.userChanges(),
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
              stream: net.auth.userChanges(),
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: () {
                      if (snapshot.hasData) {
                        pushNamed(context, "/profile");
                      } else {
                        pushNamed(context, "/sign-in");
                      }
                    },
                    icon: snapshot.hasData
                        ? const UserThumbnail()
                        : const Icon(Icons.person));
              }),
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
    );
  }
}

class UserThumbnail extends StatefulWidget {
  const UserThumbnail({super.key});

  @override
  State<UserThumbnail> createState() => _UserThumbnailState();
}

class _UserThumbnailState extends State<UserThumbnail> {
  @override
  void initState() {
    super.initState();
    future = net.currentAccount;
  }

  late Future<AccountInfo?> future;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: net.auth.userChanges(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GetImage(
                      imagePath: snapshot.data!.imagePath ?? "", size: 20);
                }
                return const CircularProgressIndicator();
              });
        });
  }
}
