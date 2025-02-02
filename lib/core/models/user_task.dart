enum TaskStatus {
  pending,
  inProgress,
  completed,
}

class UserTask {
  final String id;
  final String userId;
  final DateTime createdAt;
  String title;
  TaskStatus status;

  UserTask({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.title,
    this.status = TaskStatus.pending,
  });

  String get statusName {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.inProgress:
        return 'Em andamento';
      case TaskStatus.completed:
        return 'Concluída';
    }
  }

  void updateTitle(String newTitle) {
    title = newTitle;
  }

  void updateStatus(TaskStatus newStatus) {
    status = newStatus;
  }
}
