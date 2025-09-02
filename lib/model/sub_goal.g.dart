// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubGoalAdapter extends TypeAdapter<SubGoal> {
  @override
  final int typeId = 1;

  @override
  SubGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubGoal(
      id: fields[0] as String,
      goalId: fields[1] as String,
      title: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      isCompleted: fields[5] as bool,
      logs: (fields[6] as List).cast<DailyLog>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubGoal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.logs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
