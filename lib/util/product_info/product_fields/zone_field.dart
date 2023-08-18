import 'package:flutter/material.dart';
import 'package:samsarah/util/product_info/product_fields/ppp_floating_button.dart';
import 'package:samsarah/util/product_info/product_fields/two_choices.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import 'package:samsarah/util/tools/my_text_form_field.dart';
import 'package:samsarah/util/product_info/product_fields/controller.dart';
import '../../tools/my_text.dart';
import 'my_check_box.dart';

class ZoneField extends StatefulWidget {
  final ProductInfo? info;
  final PPPType type;
  final ProductController pc;
  const ZoneField({super.key, required this.pc, this.info, required this.type});

  @override
  State<ZoneField> createState() => _ZoneFieldState();
}

class _ZoneFieldState extends State<ZoneField>
    with AutomaticKeepAliveClientMixin {
  bool agricultural = false;
  bool industrial = false;
  bool residential = true;

  List<Widget> getChildren() {
    List<Widget> temp = [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(
          onTap: widget.info == null
              ? () {
                  agricultural = true;
                  industrial = false;
                  residential = false;
                  setState(() {});
                }
              : null,
          child: MyText(
            text: "زراعية",
            color: agricultural ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        GestureDetector(
          onTap: widget.info == null
              ? () {
                  agricultural = false;
                  industrial = true;
                  residential = false;
                  setState(() {});
                }
              : null,
          child: MyText(
            text: "صناعية",
            color: industrial ? Colors.orange : Colors.grey,
            size: 20,
          ),
        ),
        GestureDetector(
          onTap: widget.info == null
              ? () {
                  agricultural = false;
                  industrial = false;
                  residential = true;
                  setState(() {});
                }
              : null,
          child: MyText(
            text: "سكنية",
            color: residential ? Colors.blue : Colors.grey,
            size: 20,
          ),
        )
      ])
    ];
    if (industrial) {
      temp.addAll([
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.built,
            product: widget.info,
            controller: widget.pc),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.nasiah,
            product: widget.info,
            controller: widget.pc),
      ]);
    } else if (residential) {
      temp.addAll([
        TwoChoices(
            type: widget.type,
            pc: widget.pc,
            tcType: TwoChoicesType.wholeHouse,
            productInfo: widget.info),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.built,
            product: widget.info,
            controller: widget.pc),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.nasiah,
            product: widget.info,
            controller: widget.pc),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.groundFloor,
            product: widget.info,
            controller: widget.pc),
        MyCheckbox(
            type: widget.type,
            cType: CheckboxType.withFurniture,
            product: widget.info,
            controller: widget.pc),
        const SizedBox(
          height: 30,
        ),
        MyTextFormField(
            onSaved: (value) => widget.pc.roomsNum = int.parse(value!),
            validator: validateForInt,
            keyboardType: TextInputType.number,
            labelText: "عدد الغرف",
            initialValue: widget.info?.roomsNum.toString()),
        const SizedBox(
          height: 30,
        ),
        MyTextFormField(
            onSaved: (value) => widget.pc.floorsNum = int.parse(value!),
            validator: validateForInt,
            keyboardType: TextInputType.number,
            labelText: "عدد الطوابق",
            initialValue: widget.info?.floorsNum.toString()),
      ]);
    }

    return temp;
  }

  @override
  void initState() {
    super.initState();
    if (widget.info != null) {
      agricultural = widget.info?.agricultural ?? widget.pc.agricultural;
      industrial = widget.info?.industrial ?? widget.pc.industrial;
      residential = widget.info?.residential ?? widget.pc.residential;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FormField(
      onSaved: (_) {
        widget.pc.agricultural = agricultural;
        widget.pc.industrial = industrial;
        widget.pc.residential = residential;
      },
      builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getChildren()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
