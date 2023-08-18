import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:samsarah/util/database/database.dart';

class DeathButton extends StatefulWidget {
  const DeathButton({super.key});

  @override
  State<DeathButton> createState() => _DeathButtonState();
}

class _DeathButtonState extends State<DeathButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          var list =
              await (await getApplicationDocumentsDirectory()).list().toList();
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  actions: [
                    IconButton(
                        onPressed: () async {
                          for (var entery in list) {
                            if (entery.path.contains(".hive") ||
                                entery.path.contains(".lock")) {
                              await entery.delete();
                            }
                          }
                          await DataBase().init();
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                content: Text("Done"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                  content: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(list[index].toString()),
                    ),
                  )),
            );
          }
        },
        icon: const Icon(
          Icons.dangerous_outlined,
          color: Colors.red,
          size: 50,
        ));
  }
}
