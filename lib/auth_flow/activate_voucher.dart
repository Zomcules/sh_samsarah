import 'package:flutter/material.dart';
import 'package:samsarah/services/firestore_service.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/tools/my_button.dart';
import 'package:samsarah/util/tools/my_text_form_field.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class ActivateVoucherPage extends StatefulWidget {
  const ActivateVoucherPage({super.key});

  @override
  State<ActivateVoucherPage> createState() => _ActivateVoucherPageState();
}

class _ActivateVoucherPageState extends State<ActivateVoucherPage> {
  String code = "";
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("شحن الرصيد"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: MyTextFormField(
                  onSaved: (value) => code = value!,
                  validator: (value) =>
                      value == null || value == "" ? "الحقل فارغ" : null,
                  keyboardType: TextInputType.text,
                  labelText: "",
                  pppType: PPPType.createNew),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
                onPressed: tryActivateVoucher, raised: true, title: "تفعيل"),
          )
        ],
      ),
    );
  }

  void tryActivateVoucher() async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      final store = FireStoreService();
      var value = await store.voucherValue(code);
      if (value == 0) {
        if (mounted) {
          alert(context, "هذا الكود غير صحيح ");
        }
      } else {
        await store.updateCurrency(value);
        await store.deleteVoucher(code);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "+$value",
            style: const TextStyle(fontSize: 30),
          )));
        }
      }
    } else {
      alert(context, "الحقل فارغ");
    }
  }
}
