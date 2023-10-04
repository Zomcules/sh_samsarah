// ignore_for_file: avoid_print
import 'dart:math';

void main() {
  print(distance);
}

double lat1 = 19.177271584050118;
double lon1 = 30.4558128118515;

double lat2 = 19.17724102122608;
double lon2 = 30.45327930419944;

double radius = 6399.5;

num haversine(fi) => pow(sin(fi / 2), 2);
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
