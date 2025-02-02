import 'package:flutter/material.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';
import 'package:to_do_list/core/services/task/task_service.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String _task = '';
  bool _isLoading = false;

  final _taskController = TextEditingController();

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  Future<void> _addTask() async {
    final user = AuthService().currentUser;

    if (user == null) return;

    try {
      setState(() => _isLoading = true);

      await TaskService().addTask(_task, user);
    } catch (error) {
      _showError('$error');
    } finally {
      setState(() => _isLoading = false);

      _taskController.clear();
      _task = '';
    }
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
              onChanged: (title) => setState(() => _task = title),
              decoration: InputDecoration(
                labelText: 'Nova tarefa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) {
                if (_task.trim().isNotEmpty) {
                  _addTask();
                } else {
                  _showError('A tarefa não pode ser vazia.');
                }
              },
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            onPressed: () {
              if (_task.trim().isNotEmpty) {
                _addTask();
              } else {
                _showError('A tarefa não pode ser vazia.');
              }
            },
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
          )
        ],
      ),
    );
  }
}
