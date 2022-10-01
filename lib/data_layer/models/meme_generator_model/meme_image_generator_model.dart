import 'meme_generator_model.dart';

class MemeImageGeneratorModel {
  List<MemeGeneratorModel> memeGeneratorImageList;

  MemeImageGeneratorModel({required this.memeGeneratorImageList});

  factory MemeImageGeneratorModel.fromJson(Map<String, dynamic> json) {
    return MemeImageGeneratorModel(
        memeGeneratorImageList:
            _getMemeGeneratorImageList(json['data']['memes'] as List));
  }

  static List<MemeGeneratorModel> _getMemeGeneratorImageList(
      List<dynamic> json) {
    List<MemeGeneratorModel> memeImageList = [];
    for (var i = 0; i < json.length; i++) {
      memeImageList.add(MemeGeneratorModel.fromJson(json[i]));
    }
    return memeImageList;
  }
}
