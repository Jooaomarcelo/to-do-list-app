import 'package:flutter/material.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String _task = '';

  final _taskController = TextEditingController();

  Future<void> _addTask() async {
    final user = AuthService().currentUser;

    if (user == null) return;

    // await TaskService().save(_task, user);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              onChanged: (value) => setState(() => _task = value),
              decoration: InputDecoration(
                labelText: 'Nova tarefa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) {
                if (_task.trim().isNotEmpty) _addTask();
              },
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
