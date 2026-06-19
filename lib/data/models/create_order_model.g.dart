// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateOrderModelAdapter extends TypeAdapter<CreateOrderModel> {
  @override
  final int typeId = 0;

  @override
  CreateOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateOrderModel(
      id: fields[0] as String,
      orderItem: fields[1] as String,
      itemName: fields[2] as String,
      quantity: fields[3] as int,
      ordStatus: fields[4] as String,
      customerName: fields[5] as String,
      phone: fields[6] as String,
      location: fields[7] as String,
      eventDate: fields[8] as String,
      eventTime: fields[9] as String,
      notes: fields[10] as String,
      createdAt: fields[11] as DateTime,
      status: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CreateOrderModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderItem)
      ..writeByte(2)
      ..write(obj.itemName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.ordStatus)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.eventDate)
      ..writeByte(9)
      ..write(obj.eventTime)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
