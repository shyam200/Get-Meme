class RandomMemeItemModel {
  final String id;
  final String title;
  final String imageUrl;

  RandomMemeItemModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory RandomMemeItemModel.fromJson(Map<String, dynamic> json) {
    return RandomMemeItemModel(
        id: json['id'],
        title: json['title'],
        imageUrl: json['url_overridden_by_dest']);
  }
}
