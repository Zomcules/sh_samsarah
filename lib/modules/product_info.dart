import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:hive/hive.dart';
import 'package:samsarah/services/firestore_service.dart';

class ProductInfo extends HiveObject {
  final String producerId;
  final String globalId;
  int price;
  final Timestamp timeStamp;
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
  ZoneType zone;
  String? imagePath;
  osm.GeoPoint geopoint;

  ProductInfo(
      {required this.producerId,
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
      this.zone = ZoneType.residential,
      required this.timeStamp,
      required this.globalId,
      this.certified});

  Map<String, dynamic> toMap() {
    return {
      "producerId": producerId,
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
      "zoneIndex": zone.index,
      "imagePath": imagePath,
      "geopointMap": geopoint.toMap(),
      "dateTime": timeStamp,
      "certified": certified
    };
  }

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
        producerId: map["producerId"],
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
        zone: ZoneType.values[map["zoneIndex"]],
        imagePath: map["imagePath"],
        geopoint: osm.GeoPoint.fromMap(map["geopointMap"]),
        timeStamp: map["dateTime"],
        certified: map["certified"]);
  }

  factory ProductInfo.dummy(List<ProductInfo> infos, {String? globalId}) {
    return ProductInfo(
        globalId: globalId ?? Random().nextInt(99999).toString(),
        timeStamp: Timestamp.now(),
        forSale: Random().nextBool(),
        producerId: Random().nextInt(2147000000).toString(),
        floorsNum: Random().nextInt(5),
        groundFloor: Random().nextBool(),
        nasiah: Random().nextBool(),
        roomsNum: Random().nextInt(5),
        wholeHouse: Random().nextBool(),
        withFurniture: Random().nextBool(),
        price: Random().nextInt(99999999),
        comments: [],
        built: Random().nextBool(),
        geopoint: osm.GeoPoint(latitude: 0.0, longitude: 0.0),
        imagePath: "",
        producerComment: "wnsmyebdnimw?",
        services: Random().nextBool(),
        size: Random().nextInt(99999),
        certified: Random().nextBool(),
        zone: ZoneType.values[Random().nextInt(ZoneType.values.length)]);
  }

  factory ProductInfo.blank() {
    return ProductInfo(
        producerId: "",
        geopoint: osm.GeoPoint(latitude: 0, longitude: 0),
        price: 0,
        timeStamp: Timestamp.now(),
        globalId: "");
  }

  Future<void> saveToNetwork() async {
    await FireStoreService().productCollection.doc(globalId).set(this);
  }
}

List<ProductInfo> getDummyProductInfos({int number = 20}) {
  List<ProductInfo> temp = [];
  for (var i = 0; i < number; i++) {
    temp.add(ProductInfo.dummy(temp));
  }
  return temp;
}

enum ZoneType { agricultural, residential, industrial }
