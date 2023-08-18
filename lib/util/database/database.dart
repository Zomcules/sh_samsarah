import 'package:hive/hive.dart';
import 'package:samsarah/chat_app/chat_page/message.dart';
import 'package:samsarah/util/database/settings.dart';
import 'package:samsarah/util/database/type_adapters.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import 'package:path_provider/path_provider.dart';

import '../account/account_info.dart';

class DataBase {
  Future<void> init() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);

    registerAdapters();

    await openBoxes();

    await openAccountSpecificBoxes();

    await initAppData();
  }

  void registerAdapters() {
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(GeoPointAdapter());
  }

  Future<void> openBoxes() async {
    await Hive.openBox<AccountInfo>("activeaccount");
    await Hive.openBox<AccountInfo>("userAccounts");
  }

  Future<void> openAccountSpecificBoxes() async {
    if (userActiveAccount() != null) {
      await Hive.openBox<AccountInfo>(
          "${userActiveAccount()!.globalId}accountinfos");
      await Hive.openBox<ProductInfo>(
          "${userActiveAccount()!.globalId}productInfos");
      await openMessages();
    }
  }

  Future<void> initAppData() async {
    var setBox = await Hive.openBox<AppData>("appData");

    if (setBox.isEmpty) {
      setBox.add(AppData());
    }
  }

  AppData appData() {
    return Hive.box<AppData>("appData").getAt(0)!;
  }

  Box<AccountInfo> accountInfos() {
    return Hive.box<AccountInfo>(
        "${userActiveAccount()!.globalId}accountinfos");
  }

  Box<AccountInfo> userAccounts() {
    return Hive.box<AccountInfo>("userAccounts");
  }

  Box<MessageData> messages(AccountInfo info) {
    return Hive.box<MessageData>(
        "c-${userActiveAccount()!.globalId}${info.globalId}");
  }

  Box<ProductInfo> savedProducts() {
    return Hive.box<ProductInfo>(
        "${userActiveAccount()!.globalId}productInfos");
  }

  List<ProductInfo> userProducts() {
    return savedProducts()
        .values
        .where((element) =>
            element.accountInfoGlobalId == userActiveAccount()!.globalId)
        .toList();
  }

  List<ProductInfo> otherProducts() {
    return savedProducts()
        .values
        .where((element) =>
            element.accountInfoGlobalId != userActiveAccount()!.globalId)
        .toList();
  }

  AccountInfo? userActiveAccount() {
    if (Hive.box<AccountInfo>("activeaccount").isNotEmpty) {
      return Hive.box<AccountInfo>("activeaccount").getAt(0);
    }
    return null;
  }

  Box<AccountInfo> activeBox() {
    return Hive.box("activeaccount");
  }

  Future<void> changeActiveAccount({AccountInfo? info}) async {
    if (userActiveAccount() != null) {
      await userAccounts()
          .add(AccountInfo.fromMap(userActiveAccount()!.toMap()));
      await userActiveAccount()!.delete();
    }

    if (info != null) {
      await activeBox().add(AccountInfo.fromMap(info.toMap()));
      await openAccountSpecificBoxes();
      await openMessages();
    }
  }

  Future<void> openMessages() async {
    for (AccountInfo info in accountInfos().values) {
      await Hive.openBox<MessageData>(
          "c-${userActiveAccount()!.globalId}${info.globalId}");
    }
  }

  void closeMessages(AccountInfo info) {
    info.save();
    messages(info).close();
  }

  Future<void> addDummyMessages({required String localId}) async {
    Box<MessageData> temp = await Hive.openBox<MessageData>(
        "c-${userActiveAccount()!.globalId}$localId");
    temp.add(MessageData(
        fromUser: false,
        content:
            "content is being made for the mortals whome can not obey thy God.",
        dateTime: DateTime.now(),
        appendedProductsIds: []));

    temp.add(MessageData(
        fromUser: false,
        content: "Hi there",
        dateTime: DateTime.now(),
        appendedProductsIds: []));
  }
}
