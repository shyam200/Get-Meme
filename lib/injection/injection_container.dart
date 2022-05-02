import 'package:get_it/get_it.dart';

import '../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../business_layer/bloc/random_meme_bloc/random_meme_bloc.dart';
import '../data_layer/data_providers/random_meme_data_provider.dart';
import '../data_layer/repositories/random_meme_repository.dart';
import '../resources/network_constants/network_constants.dart';

///setting [di] naming from for dependency injection

final di = GetIt.instance;

Future<void> init() async {
  di.registerLazySingleton<NetworkConstants>(() => NetworkConstants());

  //!Bloc
  di.registerFactory<RandomMemeBloc>(
      () => RandomMemeBloc(randomMememRepository: di()));

  di.registerFactory<MemeGeneratorBloc>(
      () => MemeGeneratorBloc(repository: di()));

  //!Repositories
  di.registerFactory<RandomMememRepository>(
      () => RandomMememRepository(randomMemeDataAPI: di()));

  //! DataProviders
  di.registerFactory<RandomMemeDataAPI>(() => RandomMemeDataAPI());
}
