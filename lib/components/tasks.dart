import 'package:flutter/material.dart';
import 'package:to_do_list/components/task_tile.dart';
import 'package:to_do_list/core/models/user_task.dart';
import 'package:to_do_list/core/services/task/task_service.dart';

class Tasks extends StatefulWidget {
  final Function(UserTask) onTaskToggle;

  const Tasks({
    required this.onTaskToggle,
    super.key,
  });

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  void _deleteTask(UserTask task) {
    TaskService().deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserTask>>(
      stream: TaskService().tasksStream(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma tarefa cadastrada.'));
        } else {
          final tasks = snapshot.data!;
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) {
                final task = tasks[i];

                return TaskTile(
                    task: task,
                    onTaskToggle: widget.onTaskToggle,
                    onDeleted: _deleteTask);
              });
        }
      },
    );
  }
}
