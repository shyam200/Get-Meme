import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/hive/hive_local_data_source.dart';
import '../../../data_layer/models/wishlist_model/wishlist_items_model.dart';
import '../../../resources/hive_db/box_keys.dart';
import 'more_menu_event.dart';
import 'more_menu_state.dart';

class MoreMenuBloc extends Bloc<MoreMenuEvent, MoreMenuState> {
  final HiveDbLocalDataSource localDataSource;

  MoreMenuBloc({required this.localDataSource}) : super(MoreMenuLoadingState());

  // MoreMenuBloc() : super(MoreMenuLoadingState()) {
  //   on<GetWishlistItemsEvent>((event, emit) async*{
  //     yield WishlistLoadedState();
  //   });
  // }
  @override
  Stream<MoreMenuState> mapEventToState(MoreMenuEvent event) async* {
    if (event is GetWishlistItemsEvent) {
      yield* _getWishlistItems();
    }
  }

  Stream<MoreMenuState> _getWishlistItems() async* {
    yield MoreMenuLoadingState();
    //fetch from local storage
    final wishList = await localDataSource
        .getDataFromHiveDb<WishlistItemModel>(BoxKeys.memeSaveImageBoxKey);

    yield WishlistLoadedState(wishlistItems: wishList);
  }
}
