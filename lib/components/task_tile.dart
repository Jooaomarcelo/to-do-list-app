import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/core/models/user_task.dart';

class TaskTile extends StatefulWidget {
  final UserTask task;
  final Function(UserTask) onTaskToggle;
  final Function(UserTask) onDeleted;

  const TaskTile({
    required this.task,
    required this.onTaskToggle,
    required this.onDeleted,
    super.key,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tem certeza?'),
            content: const Text('Quer remover essa tarefa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => widget.onDeleted(widget.task),
      child: Card(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        elevation: 5,
        child: ExpansionTile(
          key: PageStorageKey(widget.task.id),
          initiallyExpanded: _isExpanded,
          title: Text(widget.task.title),
          subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(widget.task.createdAt)),
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
      ),
    );
  }
}
