import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ShareImageModel extends Equatable {
  final Uint8List shareImage;

  const ShareImageModel({required this.shareImage});
  @override
  List<Object?> get props => [shareImage];

  factory ShareImageModel.fromUint8List(imageBytes) {
    return ShareImageModel(shareImage: imageBytes);
  }
}
