import 'package:flutter/material.dart';
import 'package:to_do_list/core/models/user_task.dart';

class TaskEditForm extends StatelessWidget {
  final UserTask task;
  final Function() onClosed;

  const TaskEditForm({
    required this.task,
    required this.onClosed,
    super.key,
  });

  DropdownMenuItem _formatTaskStatus(TaskStatus status) {
    if (status == TaskStatus.pending) {
      return DropdownMenuItem(
        value: status,
        child: Text('Pendente'),
      );
    } else if (status == TaskStatus.inProgress) {
      return DropdownMenuItem(
        value: status,
        child: Text('Em andamento'),
      );
    } else {
      return DropdownMenuItem(
        value: status,
        child: Text('Concluída'),
      );
    }
  }

  void _submit() {
    // To do
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Editar tarefa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: onClosed,
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                TextFormField(
                  initialValue: task.title,
                ),
                DropdownButtonFormField(
                  value: task.status,
                  items: TaskStatus.values.map(_formatTaskStatus).toList(),
                  onChanged: (newStatus) {},
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  width: double.infinity,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    onPressed: _submit,
                    child: Text('Salvar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
