import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../business_layer/bloc/meme_generator_bloc/meme_generator_bloc.dart';
import '../business_layer/bloc/random_meme_bloc/random_meme_bloc.dart';
import '../core/access_permissions/access_permissions_wrapper.dart';
import '../data_layer/data_providers/random_meme_data_provider.dart';
import '../data_layer/repositories/random_meme_repository.dart';
import '../resources/network_constants/network_constants.dart';

///setting [di] naming from dependency injection

final di = GetIt.instance;

Future<void> init() async {
  di.registerLazySingleton<NetworkConstants>(() => NetworkConstants());

  //!Bloc
  di.registerFactory<RandomMemeBloc>(
      () => RandomMemeBloc(randomMememRepository: di()));

  di.registerFactory<MemeGeneratorBloc>(() =>
      MemeGeneratorBloc(repository: di(), accessPermissionsWrapper: di()));

  //!Repositories
  di.registerFactory<RandomMememRepository>(
      () => RandomMememRepository(randomMemeDataAPI: di()));

  //! DataProviders
  di.registerFactory<RandomMemeDataAPI>(() => RandomMemeDataAPI());

  //! Utils
  di.registerLazySingleton<Dio>(() => Dio());

  //!Access Permissions
  di.registerLazySingleton<AccessPermissionsWrapper>(
      () => AccessPermissionsWrapper());
}
