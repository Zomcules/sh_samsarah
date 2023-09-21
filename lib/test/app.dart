import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  late final CollectionReference collection;

  @override
  void initState() {
    super.initState();
    var instance = FirebaseFirestore.instance;
    instance.settings = const Settings(persistenceEnabled: false);
    collection = instance.collection("TestCollection");
  }

  var controller = TextEditingController();
  var scroller = ScrollController();

  void validate() {
    if (controller.value.text != "") {
      save(controller.value.text);
    }
  }

  void save(String? newValue) async {
    await collection.add({"value": newValue});
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void onPressed() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextFormField(
          controller: controller,
          onSaved: save,
          autovalidateMode: AutovalidateMode.always,
          validator: (value) =>
              (value == null || value == "") ? "Add SHit!@#" : null,
        ),
        actions: [
          IconButton(onPressed: validate, icon: const Icon(Icons.save))
        ],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: collection.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      controller: scroller,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) =>
                                snapshot.data!.docs[index].reference.delete(),
                            child: ListTile(
                              title: Text(
                                  snapshot.data!.docs[index].data().toString()),
                            ),
                          ));
                }
                return const SizedBox(
                    width: 60, height: 60, child: CircularProgressIndicator());
              },
            ),
          ),
          ElevatedButton(onPressed: onPressed, child: const Text("Add Data")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
