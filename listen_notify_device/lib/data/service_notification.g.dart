// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceNotificationAdapter extends TypeAdapter<ServiceNotification> {
  @override
  final int typeId = 0;

  @override
  ServiceNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceNotification(
      id: fields[0] as int?,
      canReply: fields[1] as bool?,
      hasExtrasPicture: fields[2] as bool?,
      hasRemoved: fields[3] as bool?,
      extrasPicture: fields[4] as Uint8List?,
      packageName: fields[5] as String?,
      title: fields[6] as String?,
      notificationIcon: fields[7] as Uint8List?,
      content: fields[8] as String?,
      dateTime: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceNotification obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.canReply)
      ..writeByte(2)
      ..write(obj.hasExtrasPicture)
      ..writeByte(3)
      ..write(obj.hasRemoved)
      ..writeByte(4)
      ..write(obj.extrasPicture)
      ..writeByte(5)
      ..write(obj.packageName)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.notificationIcon)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
