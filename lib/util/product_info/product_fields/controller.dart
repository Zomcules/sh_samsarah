import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_info.dart';

class ProductController {
  var db = DataBase();

  late GeoPoint geopoint;

  bool forSale = false;

  int price = 0;

  bool services = true;

  bool certified = true;

  bool agricultural = false;

  bool industrial = false;

  bool residential = false;

  int roomsNum = 0;

  bool wholeHouse = false;

  bool withFurniture = false;

  int size = 0;

  bool built = true;

  bool multifloor = false;

  int floorsNum = 1;

  bool groundFloor = true;

  bool nasiah = false;

  void save() {
    var x = Random().nextInt(9999).toString();
    var temp = ProductInfo(
      accountInfoGlobalId: db.userActiveAccount()!.globalId,
      geopoint: geopoint,
      forSale: forSale,
      price: price,
      dateTime: DateTime.now(),
      globalId: "${db.userActiveAccount()!.globalId}-$x",
      services: services,
      certified: certified,
      //////////
      agricultural: agricultural,
      industrial: industrial,
      residential: residential,
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
    db.savedProducts().add(temp);
  }

  getSearchFieldsMap() {}
}
