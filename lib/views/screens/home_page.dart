import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:todo_app_flutter/controllers/task_controller.dart';
import 'package:todo_app_flutter/views/screens/add_task_screen.dart';
import 'package:todo_app_flutter/views/widget/task_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    final TaskController taskController = Get.find<TaskController>();
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo List',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort, size: 24.sp, color: Colors.white),
            onSelected: (SortType value) => taskController.sortTasksBy(value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortType.priority,
                child: Text('Priority', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem(
                value: SortType.dueDate,
                child: Text('Due Date', style: TextStyle(fontSize: 14.sp)),
              ),
              PopupMenuItem(
                value: SortType.creationDate,
                child: Text('Creation Date', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: FadeInDown(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue.shade200, width: 1.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(4.w, 4.h),
                        blurRadius: 8.r,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.w, -4.h),
                        blurRadius: 8.r,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 24.sp,
                        color: Colors.blue.shade700,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    onChanged: (value) => taskController.searchTasks(value),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => taskController.filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks found. Add one now!',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        itemCount: taskController.filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = taskController.filteredTasks[index];
                          return SlideInUp(
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            child: TaskTile(
                              task: task,
                              key: ValueKey(task.id),
                            ), // Use task.id for key
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Bounce(
        child: FloatingActionButton(
          onPressed: () => Get.to(() => const AddTaskScreen()),
          backgroundColor: Colors.blue.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.add, size: 28.sp, color: Colors.white),
        ),
      ),
    );
  }
}
