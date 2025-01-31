import 'package:flutter/material.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Sair'),
              )
            ],
            onSelected: (value) {
              if (value == 'logout') AuthService().logout();
            },
          )
        ],
      ),
      body: Center(
        child: Text('Tasks'),
      ),
    );
  }
}
