import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../data_layer/models/wishlist_model/wishlist_items_model.dart';

class HiveInit {
  ///Init method for instantiating the hive configuration.

  static init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    //register all the adapters
    Hive.registerAdapter(WishlistItemModelAdapter());
  }
}
