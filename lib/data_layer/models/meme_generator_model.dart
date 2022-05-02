class MemeGeneratorModel {
  final String id;
  final String imageUrl;

  MemeGeneratorModel({required this.id, required this.imageUrl});
  factory MemeGeneratorModel.fromJson(Map<String, dynamic> json) {
    return MemeGeneratorModel(
      id: json['id'],
      imageUrl: json['url'],
    );
  }
}
