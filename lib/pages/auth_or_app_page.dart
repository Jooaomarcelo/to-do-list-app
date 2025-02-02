import 'package:flutter/material.dart';
import 'package:to_do_list/core/models/user_data.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';
import 'package:to_do_list/pages/auth_page.dart';
import 'package:to_do_list/pages/loading_page.dart';
import 'package:to_do_list/pages/tasks_page.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData?>(
      stream: AuthService().userChanges,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return snapshot.hasData ? const TasksPage() : AuthPage();
        }
      },
    );
  }
}
