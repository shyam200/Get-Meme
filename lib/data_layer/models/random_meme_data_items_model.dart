import 'random_meme_items_model.dart';

class RandomMemeDataItemsModel {
  List<RandomMemeItemModel> memeItemsList;

  RandomMemeDataItemsModel({required this.memeItemsList});

  factory RandomMemeDataItemsModel.fromJson(List<dynamic> json) {
    List<RandomMemeItemModel> memeItemList = [];
    for (var element in json) {
      memeItemList.add(RandomMemeItemModel.fromJson(element['data']));
    }

    return RandomMemeDataItemsModel(memeItemsList: memeItemList);
  }
}
