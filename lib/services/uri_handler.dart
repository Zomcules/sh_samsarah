import 'package:flutter/material.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';
import 'package:uni_links/uni_links.dart';

import '../pages/tab/chat_app/profile.dart';
import 'database_service.dart';
import '../util/product_info/product_preview_page.dart';
import '../util/product_info/product_preview_page/fields/ppp_floating_button.dart';

void initUniLinks(BuildContext context) async {
  var uri = await getInitialUri();
  if (uri != null && context.mounted) {
    _handleUri(context, uri);
  }
  debugPrint(uri.toString());
}

// StreamSubscription<Uri?> uriStream(BuildContext context) {
//   return uriLinkStream.listen((uri) {
//     if (uri != null && context.mounted) {
//       _handleUri(context, uri);
//     }
//     debugPrint(uri.toString());
//   });
// }

void _handleUri(BuildContext context, Uri uri) {
  switch (uri.path) {
    case "/products":
      push(
        context,
        FutureBuilder(
          future: Database().getProduct(uri.queryParameters["globalId"]!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text("خطأ في الشبكة"),
                ),
              );
            }
            return ProductPreviewPage(
              type: PPPType.viewExternal,
              info: snapshot.data,
            );
          },
        ),
      );
      break;
    case "/accounts":
      push(
        context,
        ProfilePage(
          id: uri.queryParameters["globalId"]!,
        ),
      );
  }
}
