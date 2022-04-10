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
