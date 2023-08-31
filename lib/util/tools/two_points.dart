import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TwoPoints {
  final GeoPoint first;
  final GeoPoint second;
  TwoPoints({required this.first, required this.second});

  double get lat1 => first.latitude;
  double get lat2 => second.latitude;
  double get lon1 => first.longitude;
  double get lon2 => second.longitude;

  double get distance =>
      acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1)) *
      6371;

  bool closerThan(double distanceInKm) => distanceInKm <= distance;
}
