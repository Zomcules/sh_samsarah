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

  bool closerThan(double distanceInKm) => distanceInKm <= distance;

  double radius = 6399.5;

  num haversine(double fi) => pow(sin(fi / 2), 2);
  double radians(double angle) => angle * pi / 180;
  double get distance {
    var latChange = radians(lat2 - lat1);
    var radLat1 = radians(lat1);
    var radLat2 = radians(lat2);
    var longChange = radians(lon2 - lon1);

    double a = haversine(latChange) +
        cos(radLat1) * cos(radLat2) * haversine(longChange);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }
}
