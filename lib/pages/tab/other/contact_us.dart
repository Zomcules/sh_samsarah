import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/database_service.dart';

import '../../../models/app_info.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late Future<DocumentSnapshot<AppInfo>> future;
  Future<DocumentSnapshot<AppInfo>> getFuture() {
    return Database().getContacts();
  }

  @override
  void initState() {
    super.initState();
    future = getFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("خطأ في الشبكة"),
              );
            }
            return ListView(
              children: [
                Image.asset("assets/app_icon_resized.jpg"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "رقم الهاتف: ${snapshot.data!.data()!.phoneNumber}",
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "عنوان البريد الالكتروني: ${snapshot.data!.data()!.email}",
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "موقعنا: ${snapshot.data!.data()!.location}",
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 24),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
