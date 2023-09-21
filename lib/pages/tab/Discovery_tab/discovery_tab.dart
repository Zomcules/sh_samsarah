import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/pages/tab/Discovery_tab/discovery_header.dart';
import 'package:samsarah/pages/tab/Discovery_tab/product_snackbar.dart';

import '../../../modules/product_info.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab>
    with AutomaticKeepAliveClientMixin {
  late Stream<QuerySnapshot<ProductInfo>> _stream;
  @override
  void initState() {
    super.initState();
    _stream = FireStoreService().productCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        const DisHeader(),
        Expanded(
          child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) => ProductSnackBar(
                        productInfo: snapshot.data!.docs[index].data()),
                  );
                }
                return const CircularProgressIndicator();
              }),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
