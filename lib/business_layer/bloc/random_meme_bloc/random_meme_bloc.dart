import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/repositories/random_meme_repository.dart';
import 'random_meme_event.dart';
import 'random_meme_state.dart';

class RandomMemeBloc extends Bloc<RandomMemeEvent, RandomMemeState> {
  final RandomMememRepository randomMememRepository;

  RandomMemeBloc({required this.randomMememRepository})
      : super(RandomMemeLoadingState());

  @override
  Stream<RandomMemeState> mapEventToState(RandomMemeEvent event) async* {
    if (event is RandomMemeLoadingEvent) {
      yield RandomMemeLoadingState();
    } else if (event is GetRandomMemeListEvent) {
      yield* getRandomMemeList();
    }
  }

  Stream<RandomMemeState> getRandomMemeList() async* {
    yield RandomMemeLoadingState();
    try {
      final result = await randomMememRepository.getRandomMemeList();
      yield RandomMemeListLoadedState(memeDataItem: result);
    } catch (e) {
      print('error fetching data:- $e');
    }
  }
}
