import 'package:flutter/material.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/tools/get_image.dart';

class AccountPreviewPage extends StatefulWidget {
  const AccountPreviewPage({super.key});

  @override
  State<AccountPreviewPage> createState() => _AccountPreviewPageState();
}

class _AccountPreviewPageState extends State<AccountPreviewPage> {
  var db = DataBase();
  var key = GlobalKey<FormState>();

  confirmSignOut({required Function popper}) {
    showDialog<bool>(
      //barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تسجيل الخروج من الحساب"),
        content: const Text("هل انت متأكد؟"),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Text(
                  "نعم",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: const Text("رجوع"))
        ],
      ),
    ).then((value) async {
      if (value!) {
        await db.changeActiveAccount();
        popper();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تعديل الحساب",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  confirmSignOut(popper: () => Navigator.pop(context)),
              icon: const Icon(
                Icons.waving_hand_outlined,
                color: Colors.red,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(children: [
            GetImage(accountInfo: db.userActiveAccount(), size: 100),
            const Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  heroTag: "0",
                  onPressed: null,
                  backgroundColor: Colors.green,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ))
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "1",
                  onPressed: () => key.currentState!.save(),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.done),
                ),
                Expanded(
                  child: Form(
                    key: key,
                    child: TextFormField(
                      initialValue: db.userActiveAccount()!.username,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        labelText: "اسم المستخدم",
                      ),
                      onSaved: (newValue) {
                        db.userActiveAccount()!.username = newValue!;
                      },
                      autovalidateMode: AutovalidateMode.always,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "الحقل لا يمكن ان يكون فارغا";
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
