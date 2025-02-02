import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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
  bool _isExpanded = false;

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

                return Card(
                  color: Colors.grey[100],
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  elevation: 5,
                  child: ExpansionTile(
                    title: Text(task.title),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(task.createdAt)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: task.status == TaskStatus.completed
                                ? Colors.lightGreenAccent
                                : task.status == TaskStatus.inProgress
                                    ? Colors.yellow
                                    : Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            task.statusName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    children: [
                      IconButton(
                        onPressed: () => widget.onTaskToggle(task),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                    onExpansionChanged: (_) =>
                        setState(() => _isExpanded = !_isExpanded),
                  ),
                );
              });
        }
      },
    );
  }
}
