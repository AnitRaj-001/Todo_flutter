import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/controllers/task_controller.dart';
import 'package:todo_app_flutter/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _dueDate;
  late String _priority;
  late bool _reminder;
  final _controller = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = widget.task?.priority ?? 'Medium';
    _reminder = widget.task?.reminder ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? '' : _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
        reminder: _reminder,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
      );
      widget.task == null
          ? _controller.addTask(task, context: context)
          : _controller.updateTask(task, context: context);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.task == null ? 'Add Task' : 'Edit Task',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                    animationDelay: 0,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                    animationDelay: 100,
                  ),
                  SizedBox(height: 16.h),
                  _buildPriorityDropdown(animationDelay: 200),
                  SizedBox(height: 16.h),
                  _buildDueDateTile(animationDelay: 300),
                  SizedBox(height: 16.h),
                  _buildReminderSwitch(animationDelay: 400),
                  SizedBox(height: 24.h),
                  ZoomIn(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 5,
                      ),
                      child: Text(
                        widget.task == null ? 'Add Task' : 'Update Task',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    String? Function(String?)? validator,
    required int animationDelay,
  }) {
    return FadeInDown(
      delay: Duration(milliseconds: animationDelay),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue, width: 1.w),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, offset: Offset(4.w, 4.h), blurRadius: 8.r),
            BoxShadow(color: Colors.white, offset: Offset(-4.w, -4.h), blurRadius: 8.r),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          style: TextStyle(fontSize: 16.sp),
          maxLines: maxLines ?? 1,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown({required int animationDelay}) {
    return FadeInDown(
      delay: Duration(milliseconds: animationDelay),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue, width: 1.w),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, offset: Offset(4.w, 4.h), blurRadius: 8.r),
            BoxShadow(color: Colors.white, offset: Offset(-4.w, -4.h), blurRadius: 8.r),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: _priority,
          decoration: InputDecoration(
            labelText: 'Priority',
            labelStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          items: ['Low', 'Medium', 'High'].map((priority) {
            return DropdownMenuItem<String>(
              value: priority,
              child: Text(priority),
            );
          }).toList(),
          onChanged: (value) => setState(() => _priority = value!),
        ),
      ),
    );
  }

  Widget _buildDueDateTile({required int animationDelay}) {
    return FadeInDown(
      delay: Duration(milliseconds: animationDelay),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue, width: 1.w),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, offset: Offset(4.w, 4.h), blurRadius: 8.r),
            BoxShadow(color: Colors.white, offset: Offset(-4.w, -4.h), blurRadius: 8.r),
          ],
        ),
        child: ListTile(
          title: Text(
            'Due Date: ${DateFormat('yyyy-MM-dd HH:mm').format(_dueDate)}',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade800),
          ),
          trailing: Icon(Icons.calendar_today, size: 24.sp, color: Colors.blue),
          onTap: _selectDateTime,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(width: 4.w, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildReminderSwitch({required int animationDelay}) {
    return FadeInDown(
      delay: Duration(milliseconds: animationDelay),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue, width: 1.w),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, offset: Offset(4.w, 4.h), blurRadius: 8.r),
            BoxShadow(color: Colors.white, offset: Offset(-4.w, -4.h), blurRadius: 8.r),
          ],
        ),
        child: SwitchListTile(
          title: Text(
            'Set Reminder (1 hour before)',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade800),
          ),
          value: _reminder,
          onChanged: (value) => setState(() => _reminder = value),
          activeColor: Colors.blue,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        ),
      ),
    );
  }
}