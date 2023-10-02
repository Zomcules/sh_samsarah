import 'package:flutter/material.dart';
import 'package:samsarah/models/account_info.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/pages/tab/chat_app/chat_page/choose_product_page.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class ProfilePage extends StatefulWidget {
  final AccountInfo? account;
  final String? id;
  const ProfilePage({super.key, this.account, this.id})
      : assert(account != null || id != null);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final acc = widget.account;
    return FutureBuilder(
        future: acc != null
            ? Future.value(acc)
            : Database().getAccount(widget.id ?? ""),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Scaffold(
                  appBar: AppBar(
                    title: Text(snapshot.data!.username),
                  ),
                  body: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfilePhoto(
                              username: snapshot.data!.username,
                              radius:
                                  MediaQuery.of(context).size.width * 3 / 10,
                              imagePath: snapshot.data!.imagePath),
                          !isLoading
                              ? MyButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await push(
                                        context,
                                        ChooseProductPage.selectFromProducts(
                                            await Database().getProductsOf(
                                                snapshot.data!.globalId)));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  raised: true,
                                  title: "الذهاب الى المعروضات")
                              : const CircularProgressIndicator()
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
