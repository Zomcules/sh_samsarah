import 'package:hive/hive.dart';

import 'package:samsarah/util/database/app_data.dart';
import 'package:samsarah/util/database/type_adapters.dart';

import 'package:path_provider/path_provider.dart';

class DataBase {
  Future<void> init() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);

    registerAdapters();

    await initAppData();
  }

  void registerAdapters() {
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(AppDataAdapter());
    Hive.registerAdapter(GeoPointAdapter());
  }

  Future<void> initAppData() async {
    var setBox = await Hive.openBox<AppData>("appData");

    if (setBox.isEmpty) {
      setBox.add(AppData());
    }
  }

  AppData get appData => Hive.box<AppData>("appData").getAt(0)!;
}
