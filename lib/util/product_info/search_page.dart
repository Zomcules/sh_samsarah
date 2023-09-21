import 'package:flutter/material.dart';
import 'package:samsarah/pages/tab/Discovery_tab/product_snackbar.dart';
import 'package:samsarah/modules/product_info.dart';
import 'package:samsarah/util/product_info/product_preview_page/controller.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/location_preview.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/my_check_box.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/ppp_floating_button.dart';
import 'package:samsarah/util/product_info/product_preview_page/fields/two_choices.dart';
import 'package:samsarah/util/tools/my_text_form_field.dart';
import 'package:samsarah/util/tools/poppers_and_pushers.dart';

class SearchPage extends StatefulWidget {
  final ProductController pc;
  const SearchPage({super.key, required this.pc});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final myKey = GlobalKey<FormState>();
  List<Widget> get list => [
        LocationPreview(
          pc: widget.pc,
          type: PPPType.search,
          validator: (geoPoint) => null,
        ),
        TwoChoices(
            pc: widget.pc,
            type: PPPType.search,
            tcType: TwoChoicesType.saleRent),
        MyTextFormField(
            pppType: PPPType.search,
            onSaved: (value) {
              if (value != null && value != "") {
                widget.pc.maxPrice = int.parse(value);
              } else {
                widget.pc.maxPrice = null;
              }
            },
            validator: validateIntNullable,
            keyboardType: TextInputType.number,
            labelText: "الحد الاعلى للسعر"),
        MyTextFormField(
            pppType: PPPType.search,
            onSaved: (value) {
              if (value != null && value != "") {
                widget.pc.minPrice = int.parse(value);
              } else {
                widget.pc.minPrice = null;
              }
            },
            validator: validateIntNullable,
            keyboardType: TextInputType.number,
            labelText: "الحد الأدنى للسعر"),
        MyCheckbox(
            type: PPPType.search,
            cType: CheckboxType.withFurniture,
            controller: widget.pc),
        const SizedBox(
          height: 50,
        )
      ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث عن العروض"),
      ),
      body: Form(
        key: myKey,
        child: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) => list[index],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (myKey.currentState!.validate()) {
            myKey.currentState!.save();
            push(context, SearchResults(list: widget.pc.search()));
          } else {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                content: Text("بعض الحقول غير صحيحة"),
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchResults extends StatefulWidget {
  final Future<List<ProductInfo>> list;
  const SearchResults({super.key, required this.list});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نتائج البحث"),
      ),
      body: FutureBuilder(
        future: widget.list,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? ListView(
                children: List<ProductSnackBar>.generate(
                    snapshot.data!.length,
                    (index) =>
                        ProductSnackBar(productInfo: snapshot.data![index])),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
