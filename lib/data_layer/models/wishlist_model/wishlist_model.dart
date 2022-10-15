import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../resources/hive_db/hive_type_id.dart';
import 'wishlist_items_model.dart';

// part 'wishlist_model.g.dart';

@HiveType(typeId: HiveTypeId.saveImageTypeId)
class WishlistModel extends Equatable {
  @HiveField(0)
  final List<WishlistItemModel> imageList;

  const WishlistModel({required this.imageList});
  @override
  List<Object?> get props => [imageList];
}
