import 'package:equatable/equatable.dart';

///********************* [More menu events]*********************

abstract class MoreMenuEvent extends Equatable {}

class GetWishlistItemsEvent extends MoreMenuEvent {
  GetWishlistItemsEvent();
  @override
  List<Object?> get props => [];
}
