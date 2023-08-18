import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import 'package:samsarah/util/product_info/product_preview_page.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

import '../../chat_app/chat_page/choose_product_page.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  void onPressed() async {
    await push<ProductInfo>(context, ChooseProductPage(
      onTap: (context, info) {
        if (mounted) {
          push(
              context,
              ProductPreviewPage(
                type: PPPType.viewInternal,
                info: info,
              ));
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(onPressed: onPressed, icon: const Icon(Icons.abc)),
    );
  }
}
