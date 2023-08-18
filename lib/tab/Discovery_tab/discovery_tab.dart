import 'package:flutter/material.dart';
import 'package:samsarah/tab/Discovery_tab/product_snackbar.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab>
    with AutomaticKeepAliveClientMixin {
  var productSnackbars = getDummyProductSnackbars();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: avoid_unnecessary_containers
    return ListView.builder(
      physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast),
      itemCount: productSnackbars.length,
      itemBuilder: (context, index) => productSnackbars.elementAt(index),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
