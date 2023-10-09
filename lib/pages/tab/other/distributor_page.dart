import 'package:flutter/material.dart';
import 'package:samsarah/models/distributer.dart';

class DistrPage extends StatelessWidget {
  final Distributer distr;
  const DistrPage({super.key, required this.distr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              distr.name,
              style: const TextStyle(fontSize: 30),
            ),
            const Text(
              "نقطة بيع رصيد سمسرة معتمدة",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(162, 9, 114, 12),
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
