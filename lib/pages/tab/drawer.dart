import 'package:flutter/material.dart';
import 'package:samsarah/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/tools/death_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../util/account/account_header.dart';
import '../../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var db = DataBase();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().auth.userChanges(),
      builder: (context, snapshot) {
        return Drawer(
          child: snapshot.hasData
              ? ListView(
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    AccountHeader(),
                    DrawerTile(
                        title: "المنتجات المحفوظة", icon: Icons.discount_sharp),
                    DeathButton()
                  ],
                )
              : Center(
                  child: GestureDetector(
                    onTap: () => pushNamed(context, "/sign-in"),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
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
