// import 'package:hive/hive.dart';
// import 'package:samsarah/models/message_data.dart';
// import 'package:samsarah/models/account_info.dart';
// import 'package:samsarah/util/database/app_data.dart';
// import 'package:samsarah/models/product_info.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// class AppDataAdapter extends TypeAdapter<AppData> {
//   @override
//   AppData read(BinaryReader reader) {
//     return AppData();
//   }

//   @override
//   final typeId = 0;

//   @override
//   void write(BinaryWriter writer, AppData obj) {}
// }

// class AccountAdapter extends TypeAdapter<AccountInfo> {
//   @override
//   AccountInfo read(BinaryReader reader) {
//     return AccountInfo(
//       username: reader.read(),
//       globalId: reader.read(),
//       imagePath: reader.read(),
//       currency: reader.read(),
//     );
//   }

//   @override
//   final typeId = 1;

//   @override
//   void write(BinaryWriter writer, AccountInfo obj) {
//     writer.write(obj.username);
//     writer.write(obj.globalId);
//     writer.write(obj.imagePath);
//     writer.write(obj.currency);
//   }
// }

// class ProductAdapter extends TypeAdapter<ProductInfo> {
//   @override
//   ProductInfo read(BinaryReader reader) {
//     return ProductInfo(
//         groundFloor: reader.read(),
//         producer: reader.read(),
//         price: reader.read(),
//         timeStamp: reader.read(),
//         globalId: reader.read(),
//         zone: ZoneType.values[reader.read()],
//         built: reader.read(),
//         comments: reader.read(),
//         floorsNum: reader.read(),
//         forSale: reader.read(),
//         geopoint: reader.read(),
//         imagePath: reader.read(),
//         nasiah: reader.read(),
//         producerComment: reader.read(),
//         roomsNum: reader.read(),
//         services: reader.read(),
//         size: reader.read(),
//         wholeHouse: reader.read(),
//         withFurniture: reader.read(),
//         certified: reader.read(),
//         likers: reader.read(),
//         bookmarkers: reader.read());
//   }

//   @override
//   final typeId = 2;

//   @override
//   void write(BinaryWriter writer, ProductInfo obj) {
//     writer.write(obj.groundFloor);
//     writer.write(obj.producer);
//     writer.write(obj.price);
//     writer.write(obj.timeStamp);
//     writer.write(obj.globalId);
//     writer.write(obj.zone.index);
//     writer.write(obj.built);
//     writer.write(obj.comments);
//     writer.write(obj.floorsNum);
//     writer.write(obj.forSale);
//     writer.write(obj.geopoint);
//     writer.write(obj.imagePath);
//     writer.write(obj.nasiah);
//     writer.write(obj.producerComment);
//     writer.write(obj.roomsNum);
//     writer.write(obj.services);
//     writer.write(obj.size);
//     writer.write(obj.wholeHouse);
//     writer.write(obj.withFurniture);
//     writer.write(obj.certified);
//     writer.write(obj.likers);
//   }
// }

// class MessageAdapter extends TypeAdapter<MessageData> {
//   @override
//   MessageData read(BinaryReader reader) {
//     return MessageData(
//       from: reader.read(),
//       content: reader.read(),
//       isRead: reader.read(),
//       timeStamp: reader.read(),
//       appendedProductsIds: reader.read().cast<String>(),
//     );
//   }

//   @override
//   final typeId = 3;

//   @override
//   void write(BinaryWriter writer, MessageData obj) {
//     writer.write(obj.from);
//     writer.write(obj.content);
//     writer.write(obj.isRead);
//     writer.write(obj.timeStamp);
//     writer.write(obj.appendedProductsIds);
//   }
// }

// class GeoPointAdapter extends TypeAdapter<GeoPoint> {
//   @override
//   GeoPoint read(BinaryReader reader) {
//     return GeoPoint(latitude: reader.read(), longitude: reader.read());
//   }

//   @override
//   final typeId = 4;

//   @override
//   void write(BinaryWriter writer, GeoPoint obj) {
//     writer.write(obj.latitude);
//     writer.write(obj.longitude);
//   }
// }
