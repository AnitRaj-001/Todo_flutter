import 'package:hive/hive.dart';
import 'package:todo_app_flutter/models/task_model.dart';

class TaskAdapter extends TypeAdapter{
  @override
  final int typeId = 0;
  @override
  read(BinaryReader reader) {
    final numberOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numberOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      priority: fields[3] as String,
      dueDate: fields[4] as DateTime,
      isCompleted: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      reminder: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.reminder);
  }
  
}