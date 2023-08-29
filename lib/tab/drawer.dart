import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/database/internet.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/tools/death_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../util/account/account_header.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var db = DataBase();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: getChildren(),
    ));
  }

  List<Widget> getChildren() {
    var temp = [
      const SizedBox(
        height: 50,
      ),
      AccountHeader(setstate: () => setState(() {})),
    ];
    if (Net().auth.currentUser != null) {
      temp.addAll([
        const DrawerTile(
            title: "المنتجات المحفوظة", icon: Icons.discount_sharp),
      ]);
    }
    temp.add(const DeathButton());
    return temp;
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const DrawerTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        title: Text(title),
        trailing: Icon(
          icon,
          color: Colors.blue,
        ),
        onTap: () => push(
            context,
            ChooseProductPage(
                onTap: (context, info) => push(
                    context,
                    ProductPreviewPage(
                      type: PPPType.viewInternal,
                      info: info,
                    )))),
      ),
    );
  }
}
