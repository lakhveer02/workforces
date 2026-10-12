enum TaskStatus {
  todo,
  inProgress,
  review,
  done,
  cancelled,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

class TaskLabel {
  final String id;
  final String name;
  final String color;

  const TaskLabel({
    required this.id,
    required this.name,
    required this.color,
  });
}

class TaskAssignee {
  final String id;
  final String name;
  final String? avatar;
  final String email;

  const TaskAssignee({
    required this.id,
    required this.name,
    this.avatar,
    required this.email,
  });
}

class TaskComment {
  final String id;
  final String taskId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final DateTime createdAt;

  const TaskComment({
    required this.id,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.createdAt,
  });
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final List<TaskAssignee> assignees;
  final List<TaskLabel> labels;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String projectId;
  final String projectName;
  final String createdById;
  final String createdByName;
  final double? estimatedHours;
  final double? actualHours;
  final List<TaskComment> comments;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignees,
    required this.labels,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.projectId,
    required this.projectName,
    required this.createdById,
    required this.createdByName,
    this.estimatedHours,
    this.actualHours,
    this.comments = const [],
  });

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.done) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  String get statusDisplayName {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.review:
        return 'Review';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get priorityDisplayName {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    List<TaskAssignee>? assignees,
    List<TaskLabel>? labels,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? projectId,
    String? projectName,
    String? createdById,
    String? createdByName,
    double? estimatedHours,
    double? actualHours,
    List<TaskComment>? comments,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignees: assignees ?? this.assignees,
      labels: labels ?? this.labels,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      comments: comments ?? this.comments,
    );
  }
}

class Project {
  final String id;
  final String name;
  final String description;
  final String color;
  final DateTime createdAt;
  final DateTime? deadline;
  final List<TaskAssignee> members;
  final int totalTasks;
  final int completedTasks;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.createdAt,
    this.deadline,
    required this.members,
    required this.totalTasks,
    required this.completedTasks,
  });

  double get progress {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }
}

class TaskStatistics {
  final int totalTasks;
  final int todoTasks;
  final int inProgressTasks;
  final int reviewTasks;
  final int doneTasks;
  final int overdueTasks;
  final double averageCompletionTime; // in days

  const TaskStatistics({
    required this.totalTasks,
    required this.todoTasks,
    required this.inProgressTasks,
    required this.reviewTasks,
    required this.doneTasks,
    required this.overdueTasks,
    required this.averageCompletionTime,
  });
}