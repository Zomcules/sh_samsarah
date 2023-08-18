import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:samsarah/tab/drawer.dart';
import 'package:samsarah/util/account/account_preview.dart';
import 'package:samsarah/util/account/choose_account.dart';
import 'package:samsarah/util/tools/get_image.dart';

import '../chat_app/messages_page.dart';
import '../util/database/database.dart';
import 'Discovery_tab/discovery_tab.dart';
import 'Discovery_tab/product_snackbar.dart';
import 'Account_tab/account_tab.dart';
import 'map_tab/map_tab.dart';

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

  var db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white
        actions: [
          ValueListenableBuilder(
            valueListenable: db.activeBox().listenable(),
            builder: (context, value, child) => IconButton(
              onPressed: value.isNotEmpty
                  ? () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const MessagesPage();
                        },
                      ));
                    }
                  : null,
              icon: const Icon(Icons.message),
            ),
          ),
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return db.userActiveAccount() != null
                          ? const AccountPreviewPage()
                          : const ChooseAccount();
                    },
                  )),
              icon: ValueListenableBuilder(
                valueListenable: db.activeBox().listenable(),
                builder: (context, value, child) => value.isEmpty
                    ? const Icon(Icons.person)
                    : GetImage(accountInfo: db.userActiveAccount(), size: 20),
              )),
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
