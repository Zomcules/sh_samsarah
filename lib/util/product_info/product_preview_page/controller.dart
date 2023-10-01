import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:samsarah/services/auth_service.dart';
import 'package:samsarah/services/database_service.dart';
import 'package:samsarah/models/product_info.dart';
import 'package:samsarah/util/tools/two_points.dart';

class ProductController {
  final auth = AuthService();
  final store = Database();

  double radius = 50;

  osm.GeoPoint? geopoint;

  bool? forSale;

  int? price;
  int? maxPrice;
  int? minPrice;

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

  Future<void> trySaveProduct(BuildContext context) async {
    String x = DateTime.now().toIso8601String();
    var temp = ProductInfo(
        producer: auth.userSnapshot,
        geopoint: geopoint ?? osm.GeoPoint(latitude: 0, longitude: 0),
        forSale: forSale ?? false,
        price: price ?? 0,
        timeStamp: Timestamp.now(),
        globalId: "${auth.uid}-$x",
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
        likers: [],
        bookmarkers: []);

    await store.tryPublishProduct(context, temp);
  }

  Future<List<ProductInfo>> search() async {
    var searchMap = {};
    if (forSale != null) {
      searchMap["forSale"] = forSale;
    }
    if (withFurniture != null) {
      searchMap["withFurniture"] = withFurniture;
    }

    var docs = (await store.productCollection.get()).docs;

    var products =
        List<ProductInfo>.generate(docs.length, (index) => docs[index].data());

    products = products.where(
      (element) {
        var elMap = element.toMap();
        bool addProduct = true;
        for (var searchEntery in searchMap.entries) {
          if (elMap[searchEntery.key] != searchEntery.value) {
            addProduct = false;
          }
        }
        return addProduct;
      },
    ).toList();
    if (geopoint != null) {
      products = products
          .where((element) =>
              TwoPoints(first: geopoint!, second: element.geopoint)
                  .closerThan(radius))
          .toList();
    }
    products = products
        .where((element) =>
            element.price <= (maxPrice ?? double.infinity) &&
            element.price >= (minPrice ?? 0))
        .toList();
    return products;
  }
}
