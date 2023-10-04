import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;

import 'account_info.dart';

class ProductInfo {
  final Map<String, dynamic> producer;
  final String globalId;
  List<String> likers;
  List<String> bookmarkers;
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
      {required this.producer,
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
      this.certified,
      required this.likers,
      required this.bookmarkers});

  Map<String, dynamic> toMap() {
    return {
      "producer": producer,
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
      "timeStamp": timeStamp,
      "certified": certified,
      "likers": likers,
      "bookmarkers": bookmarkers
    };
  }

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
        producer: map["producer"],
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
        timeStamp: map["timeStamp"],
        certified: map["certified"],
        likers: (map["likers"] as List).cast<String>(),
        bookmarkers: (map["bookmarkers"] as List).cast<String>());
  }

  factory ProductInfo.blank() {
    return ProductInfo(
        producer: AccountInfo.blank().toMap(),
        geopoint: osm.GeoPoint(latitude: 0, longitude: 0),
        price: 0,
        timeStamp: Timestamp.now(),
        globalId: "",
        likers: [],
        bookmarkers: []);
  }
}

enum ZoneType { agricultural, residential, commercial }
