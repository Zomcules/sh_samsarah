import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/pages/tab/Discovery_tab/discovery_header.dart';
import 'package:samsarah/pages/tab/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../../modules/product_info.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab>
    with AutomaticKeepAliveClientMixin {
  late Future<QuerySnapshot<ProductInfo>> _future;
  @override
  void initState() {
    super.initState();
    _future = FireStoreService().productCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        const DisHeader(),
        Expanded(
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) => ProductSnackBar.post(
                    product: snapshot.data!.docs[index].data(),
                    onTap: (info) => push(
                        context,
                        ProductPreviewPage(
                          type: PPPType.viewExternal,
                          info: info,
                        )),
                  ),
                );
              }),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
