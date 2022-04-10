import 'random_meme_data_items_model.dart';

class RandomMemeModel {
  String nextPageId;
  RandomMemeDataItemsModel memeData;

  RandomMemeModel({required this.nextPageId, required this.memeData});

  factory RandomMemeModel.fromJson(Map<String, dynamic> json) {
    return RandomMemeModel(
        nextPageId: json['data']['after'],
        memeData: RandomMemeDataItemsModel.fromJson(
            json['data']['children'] as List));
  }
}
