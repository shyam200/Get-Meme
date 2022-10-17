import 'package:equatable/equatable.dart';

///********************* [More menu events]*********************

abstract class MoreMenuEvent extends Equatable {}

class GetWishlistItemsEvent extends MoreMenuEvent {
  GetWishlistItemsEvent();
  @override
  List<Object?> get props => [];
}

class RemoveSaveItemFromWishlistEvent extends MoreMenuEvent {
  final String key;

  RemoveSaveItemFromWishlistEvent(this.key);
  @override
  List<Object?> get props => [key];
}
