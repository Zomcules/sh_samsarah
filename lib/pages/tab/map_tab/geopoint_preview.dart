import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class GeoPointPreview extends StatelessWidget {
  final GeoPoint geoPoint;
  const GeoPointPreview({super.key, required this.geoPoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text("Longitude:"),
          Text(geoPoint.longitude.toString()),
          const Text("Latitude:"),
          Text(geoPoint.latitude.toString()),
        ],
      )),
    );
  }
}
