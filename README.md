ToDoList App

A modern, responsive ToDoList app built with Flutter, featuring task management with priorities, due dates, reminders, search, and sorting. The app sports a sleek UI with gradient backgrounds, neumorphic styling, and smooth animations.

Features

Add/Edit Tasks: Create or update tasks with title, description, priority (Low/Medium/High), due date, and reminder options.
Search & Sort: Filter tasks by title/description and sort by priority, due date, or creation date.
Reminders: Schedule notifications 1 hour before task due dates using flutter_local_notifications.
Persistent Storage: Save tasks locally with Hive.
Responsive Design: Adapts to various screen sizes using flutter_screenutil.
Modern UI: Gradient backgrounds, neumorphic containers, and animations (animate_do) for a polished look.
State Management: Uses GetX for efficient controller-based architecture.

Tech Stack

Flutter: Framework for cross-platform UI.
Dart: Programming language.
GetX: State management and dependency injection.
Hive: Lightweight NoSQL database for task storage.
flutter_local_notifications: Task reminders with timezone support (Asia/Kolkata fallback).
flutter_screenutil: Responsive sizing.
animate_do: Smooth UI animations.
intl: Date/time formatting.

Key Components

HomeScreen: Displays tasks in a ListView with a search bar and sort menu. Uses TaskController for data and TaskTile for rendering.
AddTaskScreen: A form for task creation/editing with fields for title, description, priority, due date, and reminder. Features neumorphic styling, gradients, and animations.
TaskController: Manages task CRUD, search (by title/description), and sorting (by priority, due date, creation date). Integrates with TaskService and NotificationService.
TaskTile: Renders individual tasks with checkboxes, priority indicators, and edit/delete buttons.
NotificationService: Schedules/cancels reminders with timezone support.
TaskService: Handles task storage/retrieval using Hive.

Usage

Home Screen: View tasks, search by title/description, sort by priority/due date/creation date, or add a task via the FAB.
Add/Edit Task: Fill in task details (title required), select priority, set due date/time, and toggle reminder (1 hour before due).
Task Actions: Check tasks to mark complete, tap to edit, or delete via the trash icon.
Notifications: Reminders appear 1 hour before due dates (uses Asia/Kolkata if timezone detection fails).

Future Improvements

Add task categories or tags.
Support recurring tasks.
Implement cloud sync with Firebase.
Enhance animations for low-end devices.