import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/controllers/task_controller.dart';
import 'package:todo_app_flutter/models/task_model.dart';
import 'package:todo_app_flutter/views/screens/add_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    final TaskController controller = Get.find<TaskController>();

    Color getPriorityColor(String priority) {
      switch (priority) {
        case 'High':
          return Colors.red.shade400;
        case 'Medium':
          return Colors.orange.shade400;
        case 'Low':
          return Colors.green.shade400;
        default:
          return Colors.grey.shade400;
      }
    }

    return SlideInRight(
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => Get.to(() => AddTaskScreen(task: task)),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BounceInDown(
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => controller.toggleTaskCompletion(
                    task.id,
                  ), // Fixed method name
                  activeColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 40.h),
                        child: SingleChildScrollView(
                          child: Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: getPriorityColor(task.priority),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            task.priority,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            'Due: ${DateFormat('MMM d, yyyy HH:mm').format(task.dueDate)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (task.reminder) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'Reminder: 1 hour before',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZoomIn(
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20.sp,
                        color: Colors.blue.shade400,
                      ),
                      onPressed: () => Get.to(() => AddTaskScreen(task: task)),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  ZoomIn(
                    delay: Duration(milliseconds: 100),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 20.sp,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () => controller.deleteTask(task.id),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
