import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samsarah/models/sam_post.dart';
import 'package:samsarah/services/database_service.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> with AutomaticKeepAliveClientMixin {
  late Future<QuerySnapshot<SamPost>> future;
  getFuture() => Database().getFeed();

  @override
  void initState() {
    super.initState();
    future = getFuture();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data?.size ?? 0,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.all(20),
                      child: Divider(),
                    ),
                    itemBuilder: (context, index) =>
                        snapshot.data!.docs[index].data().format(),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(
          () {
            future = getFuture();
          },
        ),
        backgroundColor: Colors.blue,
        heroTag: "Refresh2",
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
