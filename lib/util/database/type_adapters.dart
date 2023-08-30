import 'package:hive/hive.dart';
import 'package:samsarah/chat_app/chat_page/message.dart';
import 'package:samsarah/util/account/account_info.dart';
import 'package:samsarah/util/database/settings.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class AppDataAdapter extends TypeAdapter<AppData> {
  @override
  AppData read(BinaryReader reader) {
    return AppData(activeAccountIndex: reader.read());
  }

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, AppData obj) {
    writer.write(obj.activeAccountIndex);
  }
}

class AccountAdapter extends TypeAdapter<AccountInfo> {
  @override
  AccountInfo read(BinaryReader reader) {
    return AccountInfo(
        username: reader.read(),
        globalId: reader.read(),
        imagePath: reader.read(),
        lastMessage: reader.read(),
        productIds: reader.read().cast<String>(),
        currency: reader.read());
  }

  @override
  final typeId = 1;

  @override
  void write(BinaryWriter writer, AccountInfo obj) {
    writer.write(obj.username);
    writer.write(obj.globalId);
    writer.write(obj.imagePath);
    writer.write(obj.lastMessage);
    writer.write(obj.productIds);
    writer.write(obj.currency);
  }
}

class ProductAdapter extends TypeAdapter<ProductInfo> {
  @override
  ProductInfo read(BinaryReader reader) {
    return ProductInfo(
      groundFloor: reader.read(),
      producerId: reader.read(),
      price: reader.read(),
      dateTime: reader.read(),
      globalId: reader.read(),
      zone: ZoneType.values[reader.read()],
      built: reader.read(),
      comments: reader.read(),
      floorsNum: reader.read(),
      forSale: reader.read(),
      geopoint: reader.read(),
      imagePath: reader.read(),
      nasiah: reader.read(),
      producerComment: reader.read(),
      roomsNum: reader.read(),
      services: reader.read(),
      size: reader.read(),
      wholeHouse: reader.read(),
      withFurniture: reader.read(),
      certified: reader.read(),
    );
  }

  @override
  final typeId = 2;

  @override
  void write(BinaryWriter writer, ProductInfo obj) {
    writer.write(obj.groundFloor);
    writer.write(obj.producerId);
    writer.write(obj.price);
    writer.write(obj.dateTime);
    writer.write(obj.globalId);
    writer.write(obj.zone.index);
    writer.write(obj.built);
    writer.write(obj.comments);
    writer.write(obj.floorsNum);
    writer.write(obj.forSale);
    writer.write(obj.geopoint);
    writer.write(obj.imagePath);
    writer.write(obj.nasiah);
    writer.write(obj.producerComment);
    writer.write(obj.roomsNum);
    writer.write(obj.services);
    writer.write(obj.size);
    writer.write(obj.wholeHouse);
    writer.write(obj.withFurniture);
    writer.write(obj.certified);
  }
}

class MessageAdapter extends TypeAdapter<MessageData> {
  @override
  MessageData read(BinaryReader reader) {
    return MessageData(
      fromUser: reader.read(),
      content: reader.read(),
      isRead: reader.read(),
      dateTime: reader.read(),
      appendedProductsIds: reader.read().cast<String>(),
    );
  }

  @override
  final typeId = 3;

  @override
  void write(BinaryWriter writer, MessageData obj) {
    writer.write(obj.fromUser);
    writer.write(obj.content);
    writer.write(obj.isRead);
    writer.write(obj.dateTime);
    writer.write(obj.appendedProductsIds);
  }
}

class GeoPointAdapter extends TypeAdapter<GeoPoint> {
  @override
  GeoPoint read(BinaryReader reader) {
    return GeoPoint(latitude: reader.read(), longitude: reader.read());
  }

  @override
  final typeId = 4;

  @override
  void write(BinaryWriter writer, GeoPoint obj) {
    writer.write(obj.latitude);
    writer.write(obj.longitude);
  }
}
