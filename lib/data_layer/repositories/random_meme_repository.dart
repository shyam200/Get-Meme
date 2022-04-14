import 'dart:convert';
import 'dart:typed_data';

import 'package:get_meme/data_layer/models/share_image_model.dart';

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

  Future<ShareImageModel> getMemeImage(imageUrl) async {
    final imageData = await randomMemeDataAPI.getImageData(imageUrl);
    return ShareImageModel.fromUint8List(imageData);
  }
}
