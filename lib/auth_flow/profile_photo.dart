import 'package:flutter/material.dart';

class ProfilePhoto extends StatefulWidget {
  final num radius;
  final String? username;
  final String? imagePath;
  const ProfilePhoto(
      {super.key,
      required this.username,
      required this.radius,
      required this.imagePath});

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            width: widget.radius >= 30 ? 3 : .5, color: Colors.cyan.shade900),
      ),
      child: CircleAvatar(
        radius: widget.radius * 1,
        foregroundImage: NetworkImage(widget.imagePath ?? ""),
        //backgroundColor: Colors.grey,
        child: Text(
          getInitials(),
          style: TextStyle(fontSize: 50, color: Colors.cyan.shade900),
        ),
      ),
    );
  }

  String getInitials() {
    if (widget.username != null) {
      var list = widget.username!.split(" ");
      var temp = [];
      for (var element in list) {
        try {
          temp.add(element[0]);
        } catch (e) {
          debugPrint("oops");
        }
      }
      return temp.join(" ");
    }
    return "NoData";
  }
}
