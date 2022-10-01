import 'dart:convert';

import '../data_providers/random_meme_data_provider.dart';
import '../models/meme_generator_model/meme_image_generator_model.dart';
import '../models/random_meme_generator_model/random_meme_model.dart';
import '../models/share_image_model.dart';

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

  Future<MemeImageGeneratorModel> getMemeGeneratorImageList() async {
    final memeImages = await randomMemeDataAPI.getMemeGeneratorImageList();
    final MemeImageGeneratorModel memeImageList =
        MemeImageGeneratorModel.fromJson(memeImages);
    return memeImageList;
  }
}
