import 'package:flutter/material.dart';
import 'package:to_do_list/core/models/user_data.dart';
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
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        // .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<UserTask> addTask(String title, UserData user) async {
    final store = FirebaseFirestore.instance;

    final task = UserTask(
      id: '',
      userId: user.id,
      createdAt: DateTime.now(),
      title: title,
    );

    debugPrint('task: ${task.status.name}');

    final docRef = await store
        .collection('tasks')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(task);

    final doc = await docRef.get();
    return doc.data()!;
  }

  @override
  Future<void> updateTask(
    String newTitle,
    TaskStatus newStatus,
    UserTask task,
  ) async {
    final store = FirebaseFirestore.instance;

    final updatedTask = UserTask(
      id: '',
      userId: task.userId,
      createdAt: task.createdAt,
      title: newTitle,
      status: newStatus,
    );

    await store
        .collection('tasks')
        .doc(task.id)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .set(updatedTask);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final store = FirebaseFirestore.instance;

    await store.collection('tasks').doc(taskId).delete();
  }

  Map<String, dynamic> _toFirestore(
    UserTask task,
    SetOptions? options,
  ) {
    return {
      'userId': task.userId,
      'createdAt': task.createdAt.toIso8601String(),
      'title': task.title,
      'status': task.status.name,
    };
  }

  UserTask _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return UserTask(
      id: doc.id,
      userId: doc['userId'],
      createdAt: DateTime.parse(doc['createdAt']),
      title: doc['title'],
      status: doc['status'] == 'pending'
          ? TaskStatus.pending
          : doc['status'] == 'inProgress'
              ? TaskStatus.inProgress
              : TaskStatus.completed,
    );
  }
}
