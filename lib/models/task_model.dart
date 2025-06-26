import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime dueDate;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  bool reminder;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
    required this.dueDate,
    required this.createdAt,
    this.reminder = false,
  });
}
