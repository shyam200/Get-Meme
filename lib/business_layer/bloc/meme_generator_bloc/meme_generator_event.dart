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
