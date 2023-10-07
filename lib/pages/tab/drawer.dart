import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/activate_voucher.dart';
import 'package:samsarah/pages/tab/auth_flow/auth_controller.dart';
import 'package:samsarah/pages/tab/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/pages/tab/other/contact_us.dart';
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/search_page.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../util/account/account_header.dart';
import '../../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().instance.userChanges(),
      builder: (context, snapshot) {
        return Drawer(
          child: snapshot.hasData
              ? ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const AccountHeader(),
                    DrawerTile(
                      title: "البحث",
                      icon: Icons.search,
                      onTap: () => push(
                        context,
                        SearchPage(
                          pc: ProductController(),
                        ),
                      ),
                    ),
                    DrawerTile(
                      title: "منتجاتي",
                      icon: Icons.discount_sharp,
                      onTap: () => push(
                        context,
                        ChooseProductPage.viewUsers(),
                      ),
                    ),
                    DrawerTile(
                      title: "اضافة منتج",
                      icon: Icons.add_location_alt,
                      onTap: () => push(context,
                          const ProductPreviewPage(type: PPPType.createNew)),
                    ),
                    DrawerTile(
                        title: "شحن الرصيد",
                        icon: Icons.monetization_on_outlined,
                        onTap: () =>
                            push(context, const ActivateVoucherPage())),
                    DrawerTile(
                        title: "اتصل بنا",
                        icon: Icons.support_agent,
                        onTap: () => push(context, const ContactUs()))
                  ],
                )
              : Center(
                  child: GestureDetector(
                    onTap: () => push(context, const AuthController()),
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
  final void Function() onTap;
  const DrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

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
        onTap: onTap,
      ),
    );
  }
}
