// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HostModelAdapter extends TypeAdapter<HostModel> {
  @override
  final int typeId = 0;

  @override
  HostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HostModel(
      title: fields[0] as dynamic,
      channelID: fields[1] as dynamic,
      date: fields[2] as dynamic,
      time: fields[3] as dynamic,
      published: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, HostModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.channelID)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.published);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
