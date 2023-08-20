import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hive/hive.dart';

class ProductInfo extends HiveObject {
  final String accountInfoGlobalId;
  final String globalId;
  int price;
  final DateTime dateTime;
  bool? certified;
  String? producerComment;
  List<Map>? comments;
  int? size;
  bool? built;
  bool forSale;
  bool? services;
  int floorsNum;
  int? roomsNum;
  bool? withFurniture;
  bool? groundFloor;
  bool? wholeHouse;
  bool? nasiah;
  bool residential;
  bool agricultural;
  bool industrial;
  String? imagePath;
  GeoPoint geopoint;

  ProductInfo(
      {required this.accountInfoGlobalId,
      required this.geopoint,
      this.imagePath,
      this.built = true,
      this.forSale = false,
      this.producerComment,
      this.services = true,
      this.size,
      required this.price,
      this.comments,
      this.floorsNum = 1,
      this.groundFloor,
      this.nasiah,
      this.roomsNum,
      this.wholeHouse,
      this.withFurniture,
      this.agricultural = false,
      this.industrial = false,
      this.residential = false,
      required this.dateTime,
      required this.globalId,
      this.certified});

  Map<String, dynamic> toMap() {
    return {
      "accountInfoGlobalId": accountInfoGlobalId,
      "globalId": globalId,
      "price": price,
      "producerComment": producerComment,
      "comments": comments,
      "size": size,
      "built": built,
      "forSale": forSale,
      "services": services,
      "floorsNum": floorsNum,
      "roomsNum": roomsNum,
      "withFurniture": withFurniture,
      "groundFloor": groundFloor,
      "wholeHouse": wholeHouse,
      "nasiah": nasiah,
      "residential": residential,
      "agricultural": agricultural,
      "industrial": industrial,
      "imagePath": imagePath,
      "geopointMap": geopoint.toMap(),
      "dateTime": dateTime.toIso8601String(),
      "certified": certified
    };
  }

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
        accountInfoGlobalId: map["accountInfoGlobalId"],
        globalId: map["globalId"],
        price: map["price"],
        producerComment: map["producerComment"],
        comments: map["comments"],
        size: map["size"],
        built: map["built"],
        forSale: map["forSale"],
        services: map["services"],
        floorsNum: map["floorsNum"],
        roomsNum: map["roomsNum"],
        withFurniture: map["withFurniture"],
        groundFloor: map["groundFloor"],
        wholeHouse: map["wholeHouse"],
        nasiah: map["nasiah"],
        residential: map["residential"],
        agricultural: map["agricultural"],
        industrial: map["industrial"],
        imagePath: map["imagePath"],
        geopoint: GeoPoint.fromMap(map["geopointMap"]),
        dateTime: DateTime.parse(map["dateTime"]),
        certified: map["certified"]);
  }

  factory ProductInfo.dummy(List<ProductInfo> infos, {String? globalId}) {
    return ProductInfo(
        globalId: globalId ?? Random().nextInt(99999).toString(),
        dateTime: DateTime.now(),
        forSale: Random().nextBool(),
        accountInfoGlobalId: Random().nextInt(2147000000).toString(),
        floorsNum: Random().nextInt(5),
        groundFloor: Random().nextBool(),
        nasiah: Random().nextBool(),
        roomsNum: Random().nextInt(5),
        wholeHouse: Random().nextBool(),
        withFurniture: Random().nextBool(),
        price: Random().nextInt(99999999),
        comments: [],
        agricultural: Random().nextBool(),
        built: Random().nextBool(),
        geopoint: GeoPoint(latitude: 0.0, longitude: 0.0),
        imagePath: "",
        industrial: Random().nextBool(),
        producerComment: "wnsmyebdnimw?",
        residential: Random().nextBool(),
        services: Random().nextBool(),
        size: Random().nextInt(99999),
        certified: Random().nextBool());
  }

  factory ProductInfo.blank() {
    return ProductInfo(
        accountInfoGlobalId: "",
        geopoint: GeoPoint(latitude: 0, longitude: 0),
        price: 0,
        dateTime: DateTime.now(),
        globalId: "");
  }
}

List<ProductInfo> getDummyProductInfos({int number = 20}) {
  List<ProductInfo> temp = [];
  for (var i = 0; i < number; i++) {
    temp.add(ProductInfo.dummy(temp));
  }
  return temp;
}
