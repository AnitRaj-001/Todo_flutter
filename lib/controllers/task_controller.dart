import 'package:get/get.dart';
import 'package:todo_app_flutter/config/notifications.dart';
import 'package:todo_app_flutter/models/task_model.dart';
import 'package:todo_app_flutter/services/task_service.dart';
import 'package:uuid/uuid.dart';

enum SortType { priority, dueDate, creationDate }

class TaskController extends GetxController {
  final TaskService _taskService = TaskService();
  final NotificationService _notificationService = NotificationService();
  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Task> filteredTasks = <Task>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<SortType> currentSort = SortType.priority.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks.assignAll(await _taskService.getTasks());
    filteredTasks.assignAll(tasks);
    sortTasks();
  }

  Future<void> addTask(Task task) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: task.title,
      description: task.description,
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: DateTime.now(),
      reminder: task.reminder,
    );
    await _taskService.saveTask(newTask);
    tasks.add(newTask);
    filterAndSortTasks();
    if (newTask.reminder) {
      await _scheduleReminder(newTask);
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    await _taskService.updateTask(updatedTask);
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      filterAndSortTasks();
      if (updatedTask.reminder) {
        await _scheduleReminder(updatedTask);
      } else {
        await _notificationService.cancelNotification(updatedTask.id.hashCode);
      }
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    tasks.removeWhere((task) => task.id == id);
    filterAndSortTasks();
    await _notificationService.cancelNotification(id.hashCode);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = tasks[index];
      task.isCompleted = !task.isCompleted;
      await _taskService.updateTask(task);
      filterAndSortTasks();
    }
  }

  void searchTasks(String query) {
    searchQuery.value = query;
    filterAndSortTasks();
  }

  void sortTasksBy(SortType sortType) {
    currentSort.value = sortType;
    sortTasks();
  }

  void sortTasks() {
    List<Task> sortedTasks = List.from(filteredTasks);
    switch (currentSort.value) {
      case SortType.priority:
        sortedTasks.sort((a, b) {
          const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return priorityOrder[a.priority]! - priorityOrder[b.priority]!;
        });
        break;
      case SortType.dueDate:
        sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortType.creationDate:
        sortedTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    filteredTasks.assignAll(sortedTasks);
  }

  void filterAndSortTasks() {
    List<Task> result = tasks;
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (task) =>
                task.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                (task.description.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                )),
          )
          .toList();
    }
    filteredTasks.assignAll(result);
    sortTasks();
  }

  Future<void> _scheduleReminder(Task task) async {
    final reminderTime = task.dueDate.subtract(const Duration(hours: 1));
    if (reminderTime.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        task.id.hashCode,
        task.title,
        'Due in 1 hour: ${task.description}',
        reminderTime,
      );
    }
  }
}
