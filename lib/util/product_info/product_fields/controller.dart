import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import '../../database/internet.dart';

class ProductController {
  var db = DataBase();

  GeoPoint geopoint = GeoPoint(latitude: 0, longitude: 0);

  bool forSale = false;

  int price = 0;

  bool services = true;

  bool certified = true;

  ZoneType zone = ZoneType.residential;

  int roomsNum = 0;

  bool wholeHouse = false;

  bool withFurniture = false;

  int size = 0;

  bool built = true;

  bool multifloor = false;

  int floorsNum = 1;

  bool groundFloor = true;

  bool nasiah = false;

  Future<void> save() async {
    var x = Random().nextInt(9999).toString();
    final net = Net();
    var temp = ProductInfo(
      accountInfoGlobalId: net.uid!,
      geopoint: geopoint,
      forSale: forSale,
      price: price,
      dateTime: DateTime.now(),
      globalId: "${net.uid}-$x",
      services: services,
      certified: certified,
      //////////
      zone: zone,
///////////////////////
      roomsNum: roomsNum,
      wholeHouse: wholeHouse,
      withFurniture: withFurniture,
      built: built,
      floorsNum: floorsNum,
      groundFloor: groundFloor,
      nasiah: nasiah,
      size: size,
    );
    db.savedProducts.add(temp);
    await temp.saveToNetwork();
  }

  getSearchFieldsMap() {}
}
