import 'dart:io';

import 'package:flutter/material.dart';
import 'package:to_do_list/components/new_task.dart';
import 'package:to_do_list/components/task_edit_form.dart';
import 'package:to_do_list/components/tasks.dart';
import 'package:to_do_list/core/models/user_task.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  static const _defaultImage = 'assets/images/avatar.png';
  final _currentUser = AuthService().currentUser;

  UserTask? _task;

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);

    if (uri.path.contains(_defaultImage)) {
      provider = const AssetImage(_defaultImage);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  void _onTaskToggle([UserTask? task]) {
    setState(() {
      if (_task == null) {
        _task = task;
      } else {
        _task = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Sair'),
                )
              ],
              onSelected: (value) {
                if (value == 'logout') AuthService().logout();
              },
              child: _showUserImage(_currentUser?.imageUrl ?? _defaultImage),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                NewTask(),
                Expanded(
                  child: Tasks(
                    onTaskToggle: _onTaskToggle,
                  ),
                )
              ],
            ),
            if (_task != null)
              TaskEditForm(task: _task!, onClosed: _onTaskToggle),
          ],
        ),
      ),
    );
  }
}
