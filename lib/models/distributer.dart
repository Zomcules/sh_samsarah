import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class Distributer {
  final String name;
  final GeoPoint geoPoint;

  const Distributer({required this.name, required this.geoPoint});

  factory Distributer.fromMap(Map<String, dynamic> map) {
    return Distributer(
      name: map["name"],
      geoPoint: GeoPoint.fromMap(
        map["geopointMap"],
      ),
    );
  }
}
