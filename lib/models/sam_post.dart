import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/auth_flow/profile_photo.dart';
import 'package:samsarah/pages/tab/chat_app/profile.dart';
import 'package:samsarah/pages/tab/tabs/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/extensions.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class SamPost {
  final String title;
  final String content;
  final DateTime time;

  SamPost({required this.title, required this.content, required this.time});

  factory SamPost.fromFirestore(Map<String, dynamic> map) {
    return SamPost(
      title: map["title"],
      content: map["content"],
      time: (map["timeStamp"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        "title": title,
        "content": content,
        "timeStamp": Timestamp.fromDate(time),
      };

  List<Widget> getElements(String source) {
    var temp = <Widget>[];
    temp.add(
      Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  time.formatDate(),
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    var elemStart = 0;
    for (int i = 0; i < source.length; i++) {
      if (source[i] == "*") {
        temp.add(
          PostElement(
            content: source.substring(elemStart, i),
          ).display(),
        );
        elemStart = i + 1;
      } else if (i == source.length - 1) {
        temp.add(
          PostElement(
            content: source.substring(elemStart, i + 1),
          ).display(),
        );
      }
    }
    return temp;
  }

  Widget format() {
    return Column(
      children: getElements(content),
    );
  }
}

class PostElement {
  String content;
  PostElement({
    required this.content,
  });

  bool get isProduct => content.startsWith("pid-");
  bool get isAcc => content.startsWith("uid-");
  bool get isText => !isProduct && !isAcc;

  late Future future;

  Widget display() {
    if (isProduct) {
      future = Database().getProduct(content.substring(4));
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductSnackBar.post(
                      onTap: (product) => push(
                        context,
                        ProductPreviewPage(
                          type: PPPType.viewExternal,
                          info: product,
                        ),
                      ),
                      product: snapshot.data!,
                    ),
                  )
                : const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
      );
    }
    if (isAcc) {
      future = Database().getAccount(content.substring(4));
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => push(
                          context,
                          ProfilePage(
                            account: snapshot.data!,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfilePhoto(
                              username: snapshot.data!.username,
                              radius: 80,
                              imagePath: snapshot.data!.imagePath),
                          Text(snapshot.data!.username),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
      );
    }
    if (isText) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
    return const Placeholder();
  }
}
