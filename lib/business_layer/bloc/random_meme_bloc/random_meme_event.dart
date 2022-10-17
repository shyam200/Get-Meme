import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class RandomMemeEvent extends Equatable {}

class RandomMemeLoadingEvent extends RandomMemeEvent {
  @override
  List<Object?> get props => [];
}

class GetRandomMemeListEvent extends RandomMemeEvent {
  @override
  List<Object?> get props => [];
}

class ShareRandomMemeEvent extends RandomMemeEvent {
  final String imgUrl;

  ShareRandomMemeEvent({required this.imgUrl});
  @override
  List<Object?> get props => [imgUrl];
}

class AddToWishlistMemeEvent extends RandomMemeEvent {
  final Image image;
  final String id;

  AddToWishlistMemeEvent({required this.id, required this.image});
  @override
  List<Object?> get props => [id, image];
}

class RemoveItemFromWishlistEvent extends RandomMemeEvent {
  final String key;

  RemoveItemFromWishlistEvent(this.key);
  @override
  List<Object?> get props => [key];
}

class FetchDbDataEvent extends RandomMemeEvent {
  @override
  List<Object?> get props => [];
}
