import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';

import '../../tools/my_text.dart';
import '../product_info.dart';
import 'controller.dart';

class TwoChoices extends StatefulWidget {
  final ProductInfo? productInfo;
  final ProductController pc;
  final PPPType type;
  final TwoChoicesType tcType;
  const TwoChoices(
      {super.key,
      this.productInfo,
      required this.pc,
      required this.type,
      required this.tcType});
  @override
  State<TwoChoices> createState() => _TwoChoicesState();
}

class _TwoChoicesState extends State<TwoChoices>
    with AutomaticKeepAliveClientMixin {
  late final _Data data;
  late bool value;
  bool editable() {
    return widget.type != PPPType.viewExternal;
  }

  @override
  void initState() {
    super.initState();
    if (widget.tcType == TwoChoicesType.saleRent) {
      value = (widget.productInfo?.forSale ?? widget.pc.forSale) ?? false;
    } else if (widget.tcType == TwoChoicesType.wholeHouse) {
      value = (widget.productInfo?.wholeHouse ?? widget.pc.wholeHouse) ?? false;
    }

    data = _Data.fromType(widget.tcType, widget.productInfo, widget.pc);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: editable()
                  ? () => setState(() {
                        value = true;
                        data.onChanged(value);
                      })
                  : null,
              child: MyText(
                text: data.firstName,
                color: value ? data.firstColor : Colors.grey,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: editable()
                  ? () => setState(() {
                        value = false;
                        data.onChanged(value);
                      })
                  : null,
              child: MyText(
                text: data.secondName,
                color: !value ? data.secondColor : Colors.grey,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum TwoChoicesType { saleRent, wholeHouse }

class _Data {
  final String firstName;
  final Color firstColor;
  final String secondName;
  final Color secondColor;
  final Function(bool value) onChanged;
  _Data._(
      {required this.onChanged,
      required this.firstName,
      required this.firstColor,
      required this.secondName,
      required this.secondColor});

  factory _Data.fromType(
      TwoChoicesType type, ProductInfo? product, ProductController controller) {
    switch (type) {
      case TwoChoicesType.saleRent:
        return _Data._(
            firstName: "للبيع",
            firstColor: Colors.red,
            secondName: "للايجار",
            secondColor: Colors.blue,
            onChanged: (bool value) {
              controller.forSale = value;
            });

      case TwoChoicesType.wholeHouse:
        return _Data._(
            firstName: "بيت كامل",
            firstColor: Colors.blue,
            secondName: "نصف بيت",
            secondColor: Colors.blue,
            onChanged: (bool value) {
              controller.wholeHouse = value;
            });
      default:
        return _Data._(
            firstName: "firstName",
            firstColor: Colors.black,
            secondName: "secondName",
            secondColor: Colors.black,
            onChanged: (bool value) {});
    }
  }
}
