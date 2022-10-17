import 'package:equatable/equatable.dart';
import 'package:get_meme/data_layer/models/wishlist_model/wishlist_items_model.dart';

import '../../../data_layer/models/random_meme_generator_model/random_meme_model.dart';

abstract class RandomMemeState extends Equatable {}

class RandomMemeLoadingState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}

class RandomMemeListLoadedState extends RandomMemeState {
  final RandomMemeModel memeDataItem;

  RandomMemeListLoadedState({required this.memeDataItem});
  @override
  List<Object?> get props => [memeDataItem];
}

class ShareRandomMemeState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}

class AddToFavouriteMemeState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}

class ItemAddedToWishlistState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}

class DbDataReceivedState extends RandomMemeState {
  final List<WishlistItemModel> wishlistItems;

  DbDataReceivedState(this.wishlistItems);
  @override
  List<Object?> get props => [wishlistItems];
}

class WishlistItemRemovedState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}
