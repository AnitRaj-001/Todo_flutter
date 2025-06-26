import 'package:hive/hive.dart';
import 'package:todo_app_flutter/models/task_model.dart';

class TaskService {
  final Box<Task> _taskBox;

  TaskService() : _taskBox = Hive.box<Task>('tasks');

  Future<List<Task>> getTasks() async {
    return _taskBox.values.toList();
  }

  Future<void> saveTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }
}
