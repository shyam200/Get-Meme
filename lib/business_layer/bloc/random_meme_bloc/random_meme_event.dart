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

class AddToFavouriteMemeEvent extends RandomMemeEvent {
  @override
  List<Object?> get props => [];
}
