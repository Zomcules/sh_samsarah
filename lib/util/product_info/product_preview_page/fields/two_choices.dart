import 'package:flutter/material.dart';

import '../../../tools/my_text.dart';
import '../../../../modules/product_info.dart';
import '../controller.dart';
import 'ppp_floating_button.dart';

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

  bool get shouldSwitch => widget.type != PPPType.viewExternal;
  bool get updateProduct => widget.productInfo != null && shouldSwitch;

  @override
  void initState() {
    super.initState();
    if (widget.tcType == TwoChoicesType.saleRent) {
      value = widget.productInfo?.forSale ?? false;
    } else if (widget.tcType == TwoChoicesType.wholeHouse) {
      value = widget.productInfo?.wholeHouse ?? false;
    }
    data = _Data.fromType(
        widget.tcType, widget.productInfo, widget.pc, widget.type);
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
              onTap: () => setState(() {
                shouldSwitch ? value = true : null;
                switch (widget.tcType) {
                  case TwoChoicesType.saleRent:
                    widget.pc.forSale = value;
                    updateProduct ? widget.productInfo!.forSale = value : null;
                    break;
                  case TwoChoicesType.wholeHouse:
                    widget.pc.wholeHouse = value;
                    updateProduct
                        ? widget.productInfo!.wholeHouse = value
                        : null;
                    break;
                  default:
                }
              }),
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
              onTap: () => setState(() {
                shouldSwitch ? value = false : null;
                switch (widget.tcType) {
                  case TwoChoicesType.saleRent:
                    widget.pc.forSale = value;
                    updateProduct ? widget.productInfo!.forSale = value : null;
                    break;
                  case TwoChoicesType.wholeHouse:
                    widget.pc.wholeHouse = value;
                    updateProduct
                        ? widget.productInfo!.wholeHouse = value
                        : null;
                    break;
                  default:
                }
              }),
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

  _Data._({
    required this.firstName,
    required this.firstColor,
    required this.secondName,
    required this.secondColor,
  });

  factory _Data.fromType(
    TwoChoicesType type,
    ProductInfo? product,
    ProductController controller,
    PPPType pppType,
  ) {
    switch (type) {
      case TwoChoicesType.saleRent:
        return _Data._(
          firstName: "للبيع",
          firstColor: Colors.red,
          secondName: "للايجار",
          secondColor: Colors.blue,
        );

      case TwoChoicesType.wholeHouse:
        return _Data._(
          firstName: "بيت كامل",
          firstColor: Colors.blue,
          secondName: "نصف بيت",
          secondColor: Colors.blue,
        );
      default:
        return _Data._(
          firstName: "firstName",
          firstColor: Colors.black,
          secondName: "secondName",
          secondColor: Colors.black,
        );
    }
  }
}
