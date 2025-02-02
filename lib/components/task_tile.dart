import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/core/models/user_task.dart';

class TaskTile extends StatefulWidget {
  final UserTask task;
  final Function(UserTask) onTaskToggle;

  const TaskTile({
    required this.task,
    required this.onTaskToggle,
    super.key,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      elevation: 5,
      child: ExpansionTile(
        key: PageStorageKey(widget.task.id),
        initiallyExpanded: _isExpanded,
        title: Text(widget.task.title),
        subtitle:
            Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.task.createdAt)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.task.status == TaskStatus.completed
                    ? Colors.lightGreenAccent
                    : widget.task.status == TaskStatus.inProgress
                        ? Colors.yellow
                        : Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.task.statusName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
            ),
          ],
        ),
        children: [
          IconButton(
            onPressed: () => widget.onTaskToggle(widget.task),
            icon: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
          ),
        ],
        onExpansionChanged: (value) {
          setState(() => _isExpanded = value);
        },
      ),
    );
  }
}
