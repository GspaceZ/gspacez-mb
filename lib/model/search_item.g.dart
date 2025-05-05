// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchItemAdapter extends TypeAdapter<SearchItem> {
  @override
  final int typeId = 0;

  @override
  SearchItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchItem(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String?,
      type: fields[3] as SearchType,
      title: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
