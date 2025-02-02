import 'package:to_do_list/core/models/user_data.dart';
import 'package:to_do_list/core/models/user_task.dart';
import 'package:to_do_list/core/services/task/task_firebase_service.dart';

abstract class TaskService {
  Stream<List<UserTask>> tasksStream();

  Future<UserTask> addTask(String title, UserData user);

  Future<void> updateTask(UserTask task);

  Future<void> deleteTask(UserTask task);

  factory TaskService() => TaskFirebaseService();
}
