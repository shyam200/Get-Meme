// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_items_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistItemModelAdapter extends TypeAdapter<WishlistItemModel> {
  @override
  final int typeId = 0;

  @override
  WishlistItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemModel(
      memeSaveImage: fields[0] as Uint8List,
      key: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.memeSaveImage)
      ..writeByte(1)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
