import 'package:to_do_list/core/models/user_task.dart';
import 'package:to_do_list/core/services/auth/auth_service.dart';
import 'package:to_do_list/core/services/task/task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskFirebaseService implements TaskService {
  @override
  Stream<List<UserTask>> tasksStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('tasks')
        .where('userId', isEqualTo: AuthService().currentUser!.id)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> addTask(UserTask task) async {}

  @override
  Future<void> updateTask(UserTask task) async {}

  @override
  Future<void> deleteTask(UserTask task) async {}

  UserTask _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return UserTask(
      id: doc.id,
      userId: doc['userId'],
      createdAt: DateTime.parse(doc['createdAt']),
      title: doc['title'],
    );
  }

  Map<String, dynamic> _toFirestore(
    UserTask task,
    SetOptions? options,
  ) {
    return {
      'userId': task.userId,
      'createdAt': task.createdAt.toIso8601String(),
      'title': task.title,
    };
  }
}
