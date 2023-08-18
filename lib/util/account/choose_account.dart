import 'package:flutter/material.dart';
import 'package:samsarah/util/account/u_account_list_tile.dart';
import 'package:samsarah/util/account/sign_in_page.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class ChooseAccount extends StatefulWidget {
  const ChooseAccount({super.key});

  @override
  State<ChooseAccount> createState() => _ChooseAccountState();
}

class _ChooseAccountState extends State<ChooseAccount> {
  final db = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(db.userActiveAccount() != null
            ? db.userActiveAccount()!.username
            : "No Active"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: db.userAccounts().length,
              itemBuilder: (context, index) => UAccountListTile(
                info: db.userAccounts().getAt(index)!,
                refresh: () => setState(() {}),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)],
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
                onPressed: () =>
                    push<bool>(context, SignInPage()).then((value) {
                      if (value != null) {
                        if (value) {
                          pop(context, true);
                        }
                      }
                    }),
                icon: const Text(
                  "انشاء حساب جديد",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
