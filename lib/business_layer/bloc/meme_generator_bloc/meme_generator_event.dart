import 'dart:ui';

import 'package:equatable/equatable.dart';

///This class emits different types of events for [meme generator] that will [dispatch from UI]

abstract class MemeGeneratorEvent extends Equatable {}

class MemeGeneratorLoadingEvent extends MemeGeneratorEvent {
  @override
  List<Object?> get props => [];
}

class MemeGeneratorGetImageListEvent extends MemeGeneratorEvent {
  MemeGeneratorGetImageListEvent();
  @override
  List<Object?> get props => [];
}

class MemeGeneratorSaveImageEvent extends MemeGeneratorEvent {
  MemeGeneratorSaveImageEvent();

  @override
  List<Object?> get props => [];
}

class PermissionGrantedEvent extends MemeGeneratorEvent {
  final Image image;
  PermissionGrantedEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

class AddImageToWishlistEvent extends MemeGeneratorEvent {
  final String key;
  final Image image;

  AddImageToWishlistEvent({required this.key, required this.image});
  @override
  List<Object?> get props => [image, key];
}

class FetchDbDataListEvent extends MemeGeneratorEvent {
  @override
  List<Object?> get props => [];
}

class RemoveItemFromWishlistEvent extends MemeGeneratorEvent {
  final String key;

  RemoveItemFromWishlistEvent({required this.key});
  @override
  List<Object?> get props => [key];
}
