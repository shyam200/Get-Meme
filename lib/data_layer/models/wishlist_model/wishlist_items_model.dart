import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../resources/hive_db/hive_type_id.dart';

part 'wishlist_items_model.g.dart';

@HiveType(typeId: HiveTypeId.saveImageTypeId)
class WishlistItemModel extends Equatable {
  @HiveField(0)
  final Uint8List memeSaveImage;
  @HiveField(1)
  final String key;
  const WishlistItemModel({required this.memeSaveImage, required this.key});

  @override
  List<Object?> get props => [memeSaveImage, key];
}
