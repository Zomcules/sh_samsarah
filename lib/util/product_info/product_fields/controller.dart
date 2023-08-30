import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:samsarah/util/database/database.dart';
import 'package:samsarah/util/product_info/product_info.dart';

import '../../database/internet.dart';

class ProductController {
  var db = DataBase();

  GeoPoint? geopoint;

  bool? forSale;

  int? price;

  bool? services;

  bool? certified;

  ZoneType? zone;

  int? roomsNum;

  bool? wholeHouse;

  bool? withFurniture;

  int? size;

  bool? built;

  bool? multifloor;

  int? floorsNum;

  bool? groundFloor;

  bool? nasiah;

  Future<void> save() async {
    String x = DateTime.now().toIso8601String();
    final net = Net();
    var temp = ProductInfo(
      producerId: net.uid!,
      geopoint: geopoint ?? GeoPoint(latitude: 0, longitude: 0),
      forSale: forSale ?? false,
      price: price ?? 0,
      dateTime: DateTime.now(),
      globalId: "${net.uid}-$x",
      services: services ?? true,
      certified: certified ?? true,
      //////////
      zone: zone ?? ZoneType.residential,
///////////////////////
      roomsNum: roomsNum ?? 1,
      wholeHouse: wholeHouse ?? false,
      withFurniture: withFurniture ?? false,
      built: built ?? true,
      floorsNum: floorsNum ?? 1,
      groundFloor: groundFloor ?? true,
      nasiah: nasiah ?? false,
      size: size ?? 0,
    );
    await temp.saveToNetwork();
    await temp.saveToDisk();
  }

  Future<List<ProductInfo>> search(BuildContext context) async {
    var searchMap = {};
    if (price != null) {
      searchMap["price"] = price;
    }
    if (forSale != null) {
      searchMap["forSale"] = forSale;
    }
    if (wholeHouse != null) {
      searchMap["wholeHouse"] = wholeHouse;
    }
    if (withFurniture != null) {
      searchMap["withFurniture"] = withFurniture;
    }
    if (geopoint != null) {
      searchMap["geopointMap"] = geopoint!.toMap();
    }

    var docs = (await Net().productCollection.get()).docs;

    var allProducts =
        List<ProductInfo>.generate(docs.length, (index) => docs[index].data());

    var qualifyingProducts = allProducts.where((element) {
      var elMap = element.toMap();
      bool theOne = true;
      for (var searchEntery in searchMap.entries) {
        if (elMap[searchEntery.key] != searchEntery.value) {
          theOne = false;
        }
      }
      return theOne;
    });
    return qualifyingProducts.toList();
  }
}
