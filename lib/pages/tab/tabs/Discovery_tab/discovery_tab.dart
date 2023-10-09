import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/pages/tab/tabs/Discovery_tab/discovery_header.dart';
import 'package:samsarah/pages/tab/tabs/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../../models/product_info.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab>
    with AutomaticKeepAliveClientMixin {
  late Future<QuerySnapshot<ProductInfo>> _future;
  Future<QuerySnapshot<ProductInfo>> getFuture([DocumentSnapshot? snap]) {
    var quer = Database()
        .productCollection
        .orderBy("timeStamp", descending: true)
        .limit(batchSize);
    if (snap != null) {
      return quer.startAfterDocument(snap).get();
    }
    return quer.get();
  }

  int batchSize = 50;

  @override
  void initState() {
    super.initState();
    _future = getFuture();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Scaffold(
          body: () {
            if (snapshot.hasError) {
              return const Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              itemCount: snapshot.data!.docs.length + 2,
              itemBuilder: (context, index) =>
                  builder(context, index, snapshot),
            );
          }(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setState(() {
              _future = getFuture();
            }),
            heroTag: "Refresh",
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget builder(BuildContext context, int index,
      AsyncSnapshot<QuerySnapshot<ProductInfo>> snapshot) {
    if (index == 0) {
      return const DisHeader();
    }
    if (index == snapshot.data!.size + 1) {
      if (snapshot.data!.size == batchSize) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                        onPressed: () {
                          setState(
                            () {
                              _future =
                                  getFuture(snapshot.data?.docs.lastOrNull);
                            },
                          );
                        },
                        raised: true,
                        title: "عرض المزيد"),
                  )
                ],
              )
            ],
          ),
        );
      }
      return const SizedBox(
        height: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "-----------نهاية العروض-----------",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ProductSnackBar.post(
      key: UniqueKey(),
      product: snapshot.data!.docs[index - 1].data(),
      onTap: (info) => push(
        context,
        ProductPreviewPage(
          type: PPPType.viewExternal,
          info: info,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
