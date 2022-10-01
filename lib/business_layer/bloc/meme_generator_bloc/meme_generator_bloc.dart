import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/repositories/random_meme_repository.dart';
import 'meme_generator_event.dart';
import 'meme_generator_state.dart';

class MemeGeneratorBloc extends Bloc<MemeGeneratorEvent, MemeGeneratorState> {
  final RandomMememRepository repository;

  MemeGeneratorBloc({required this.repository})
      : super(MemeGeneratorLoadingState());
  @override
  Stream<MemeGeneratorState> mapEventToState(event) async* {
    if (event is MemeGeneratorLoadingEvent) {
      yield MemeGeneratorLoadingState();
    } else if (event is MemeGeneratorGetImageListEvent) {
      yield* _getImageDataList();
    }
  }
  //   on<MemeGeneratorEvent>((event, emit) async {
  //     if (event is MemeGeneratorLoadingEvent) {
  //       MemeGeneratorLoadingState();
  //     } else if (event is MemeGeneratorGetImageListEvent) {
  //       _getImageDataList();
  //     }
  //   });
  // }

  Stream<MemeGeneratorState> _getImageDataList() async* {
    yield MemeGeneratorLoadingState();
    try {
      final imageList = await repository.getMemeGeneratorImageList();
      yield MemeGeneratorListLoadedState(imageList: imageList);
    } catch (e) {
      log('unable to fetch data:- $e');
    }
  }
}
