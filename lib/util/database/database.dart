import 'package:hive/hive.dart';
import 'package:samsarah/chat_app/chat_page/message.dart';
import 'package:samsarah/util/database/settings.dart';
import 'package:samsarah/util/database/type_adapters.dart';
import 'package:samsarah/util/product_info/product_info.dart';
import 'package:path_provider/path_provider.dart';

import '../account/account_info.dart';
import 'internet.dart';

class DataBase {
  Future<void> init() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);

    registerAdapters();

    await openBoxes();

    await openAccountSpecificBoxes();

    await initAppData();
  }

  final net = Net();

  void registerAdapters() {
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(AppDataAdapter());
    Hive.registerAdapter(GeoPointAdapter());
  }

  Future<void> openBoxes() async {
    await Hive.openBox<AccountInfo>("activeaccount");
    await Hive.openBox<AccountInfo>("userAccounts");
  }

  Future<void> openAccountSpecificBoxes() async {
    if (net.isSignedIn) {
      await Hive.openBox<AccountInfo>("${net.uid}accountinfos");
      await Hive.openBox<ProductInfo>("${net.uid}productInfos");
      await openMessages();
    }
  }

  Future<void> initAppData() async {
    var setBox = await Hive.openBox<AppData>("appData");

    if (setBox.isEmpty) {
      setBox.add(AppData());
    }
  }

  AppData get appData => Hive.box<AppData>("appData").getAt(0)!;

  Box<AccountInfo> get accountInfos =>
      Hive.box<AccountInfo>("${net.uid}accountinfos");

  Box<AccountInfo> get userAccounts => Hive.box<AccountInfo>("userAccounts");

  Box<MessageData> messages(AccountInfo info) {
    return Hive.box<MessageData>("c-${net.uid}${info.globalId}");
  }

  Box<ProductInfo> get savedProducts =>
      Hive.box<ProductInfo>("${net.uid}productInfos");

  List<ProductInfo> get userProducts => savedProducts.values
      .where((element) => element.producerId == net.uid)
      .toList();

  List<ProductInfo> get otherProducts {
    return savedProducts.values
        .where((element) => element.producerId != net.uid)
        .toList();
  }

  Box<AccountInfo> get activeBox {
    return Hive.box("activeaccount");
  }

  Future<void> openMessages() async {
    for (AccountInfo info in accountInfos.values) {
      await Hive.openBox<MessageData>("c-${net.uid}${info.globalId}");
    }
  }

  void closeMessages(AccountInfo info) {
    info.save();
    messages(info).close();
  }

  Future<void> addDummyMessages({required String localId}) async {
    Box<MessageData> temp =
        await Hive.openBox<MessageData>("c-${net.uid}$localId");
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
