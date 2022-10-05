import 'package:equatable/equatable.dart';

import '../../../data_layer/models/meme_generator_model/meme_image_generator_model.dart';

///This class emits different types of [states] for meme generator Image [from bloc]

abstract class MemeGeneratorState extends Equatable {}

class MemeGeneratorLoadingState extends MemeGeneratorState {
  @override
  List<Object?> get props => [];
}

class MemeGeneratorListLoadedState extends MemeGeneratorState {
  final MemeImageGeneratorModel imageList;
  MemeGeneratorListLoadedState({required this.imageList});
  @override
  List<Object?> get props => [imageList];
}

class MemeGeneratorImageSavedSucessState extends MemeGeneratorState {
  @override
  List<Object?> get props => [];
}
