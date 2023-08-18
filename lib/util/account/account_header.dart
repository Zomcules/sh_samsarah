import 'package:flutter/material.dart';
import 'package:samsarah/util/account/account_preview.dart';
import 'package:samsarah/util/account/choose_account.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/tools/get_image.dart';

class AccountHeader extends StatefulWidget {
  final Function setstate;
  const AccountHeader({super.key, required this.setstate});

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  var db = DataBase();
  @override
  Widget build(BuildContext context) {
    if (db.userActiveAccount() != null) {
      return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountPreviewPage(),
            )).then((value) {
          setState(() {});
          widget.setstate();
        }),
        child: Container(
          height: 150,
          decoration: const BoxDecoration(color: Colors.blue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetImage(accountInfo: db.userActiveAccount()!, size: 50),
              Text(
                db.userActiveAccount()!.username,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
              margin: const EdgeInsets.all(10),
              child: GetImage(accountInfo: db.userActiveAccount(), size: 50)),
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
                onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChooseAccount(),
                        )).then((value) {
                      setState(() {});
                      widget.setstate();
                    }),
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
    }
  }
}
