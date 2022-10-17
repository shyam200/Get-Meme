import 'package:equatable/equatable.dart';

import '../../../data_layer/models/wishlist_model/wishlist_items_model.dart';

/// ******************************* [More menu states] ************************

abstract class MoreMenuState extends Equatable {}

class MoreMenuLoadingState extends MoreMenuState {
  @override
  List<Object?> get props => [];
}

class WishlistLoadedState extends MoreMenuState {
  final List<WishlistItemModel>? wishlistItems;

  WishlistLoadedState({required this.wishlistItems});

  @override
  List<Object?> get props => [wishlistItems];
}

class WishlistItemRemovedSate extends MoreMenuState {
  final String key;

  WishlistItemRemovedSate(this.key);
  @override
  List<Object?> get props => [key];
}
