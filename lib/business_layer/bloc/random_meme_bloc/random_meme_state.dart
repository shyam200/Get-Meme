import 'package:equatable/equatable.dart';

import '../../../data_layer/models/random_meme_model.dart';

abstract class RandomMemeState extends Equatable {}

class RandomMemeLoadingState extends RandomMemeState {
  @override
  List<Object?> get props => [];
}

class RandomMemeListLoadedState extends RandomMemeState {
  final RandomMemeModel memeDataItem;

  RandomMemeListLoadedState({required this.memeDataItem});
  @override
  List<Object?> get props => [];
}
