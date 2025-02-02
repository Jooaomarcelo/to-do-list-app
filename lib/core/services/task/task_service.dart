import 'package:to_do_list/core/models/user_task.dart';
import 'package:to_do_list/core/services/task/task_firebase_service.dart';

abstract class TaskService {
  Stream<List<UserTask>> tasksStream();

  Future<void> addTask(UserTask task);

  Future<void> updateTask(UserTask task);

  Future<void> deleteTask(UserTask task);

  factory TaskService() => TaskFirebaseService();
}
