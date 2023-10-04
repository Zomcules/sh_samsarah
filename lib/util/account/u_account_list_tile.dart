import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/models/account_info.dart';

class UAccountListTile extends StatefulWidget {
  final AccountInfo info;
  final Function refresh;
  const UAccountListTile(
      {super.key, required this.info, required this.refresh});

  @override
  State<UAccountListTile> createState() => _UAccountListTileState();
}

class _UAccountListTileState extends State<UAccountListTile> {
  void confirmDelete(BuildContext context) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف الحساب من الجهاز"),
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
            icon: const Text("رجوع"),
          )
        ],
      ),
    ).then(
      (value) async {
        if (value!) {
          widget.refresh();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(15),
      title: Text(widget.info.username),
      onTap: () async {
        Navigator.pop(context);
      },
      leading: ProfilePhoto(
        imagePath: widget.info.imagePath ?? "",
        radius: 30,
        username: widget.info.username,
      ),
      trailing: IconButton(
        onPressed: () => confirmDelete(context),
        icon: const Icon(
          Icons.delete_outlined,
          color: Colors.red,
        ),
      ),
    );
  }
}
