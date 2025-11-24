// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedDataModelAdapter extends TypeAdapter<CachedDataModel> {
  @override
  final int typeId = 0;

  @override
  CachedDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedDataModel(
      key: fields[0] as String,
      data: fields[1] as String,
      createdAt: fields[2] as DateTime,
      expiresAt: fields[3] as DateTime,
      dataType: fields[4] as String,
      siteId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CachedDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.expiresAt)
      ..writeByte(4)
      ..write(obj.dataType)
      ..writeByte(5)
      ..write(obj.siteId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
