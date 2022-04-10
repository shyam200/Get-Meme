import 'dart:convert';

import '../data_providers/random_meme_data_provider.dart';
import '../models/random_meme_model.dart';

class RandomMememRepository {
  final RandomMemeDataAPI randomMemeDataAPI;

  RandomMememRepository({required this.randomMemeDataAPI});

  Future<RandomMemeModel> getRandomMemeList() async {
    final dynamic rawDataList = await randomMemeDataAPI.getRawMemeData();
    final RandomMemeModel memeModel =
        RandomMemeModel.fromJson(json.decode(rawDataList));
    return memeModel;
  }
}
