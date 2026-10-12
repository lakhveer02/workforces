import '../domain/task_models.dart';

class MockTaskRepository {
  static final MockTaskRepository _instance = MockTaskRepository._internal();
  factory MockTaskRepository() => _instance;
  MockTaskRepository._internal();

  // Mock data
  final List<TaskAssignee> _assignees = [
    TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
    TaskAssignee(id: 'emp_002', name: 'Jane Smith', email: 'jane.smith@workforce.com'),
    TaskAssignee(id: 'emp_003', name: 'Mike Johnson', email: 'mike.johnson@workforce.com'),
    TaskAssignee(id: 'emp_004', name: 'Sarah Connor', email: 'sarah.connor@workforce.com'),
  ];

  final List<TaskLabel> _labels = [
    TaskLabel(id: 'bug', name: 'Bug', color: '#EF4444'),
    TaskLabel(id: 'feature', name: 'Feature', color: '#10B981'),
    TaskLabel(id: 'enhancement', name: 'Enhancement', color: '#3B82F6'),
    TaskLabel(id: 'documentation', name: 'Documentation', color: '#8B5CF6'),
    TaskLabel(id: 'urgent', name: 'Urgent', color: '#F59E0B'),
  ];

  final List<Project> _projects = [
    Project(
      id: 'proj_001',
      name: 'WorkforceOS Mobile',
      description: 'Mobile application for workforce management',
      color: '#3B82F6',
      createdAt: DateTime(2024, 1, 15),
      deadline: DateTime(2024, 12, 31),
      members: [
        TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
        TaskAssignee(id: 'emp_002', name: 'Jane Smith', email: 'jane.smith@workforce.com'),
      ],
      totalTasks: 25,
      completedTasks: 18,
    ),
    Project(
      id: 'proj_002',
      name: 'HR Dashboard',
      description: 'Web dashboard for HR management',
      color: '#10B981',
      createdAt: DateTime(2024, 2, 1),
      deadline: DateTime(2024, 11, 30),
      members: [
        TaskAssignee(id: 'emp_003', name: 'Mike Johnson', email: 'mike.johnson@workforce.com'),
        TaskAssignee(id: 'emp_004', name: 'Sarah Connor', email: 'sarah.connor@workforce.com'),
      ],
      totalTasks: 15,
      completedTasks: 8,
    ),
    Project(
      id: 'proj_003',
      name: 'Payroll System',
      description: 'Automated payroll processing system',
      color: '#F59E0B',
      createdAt: DateTime(2024, 3, 1),
      members: [
        TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
        TaskAssignee(id: 'emp_003', name: 'Mike Johnson', email: 'mike.johnson@workforce.com'),
      ],
      totalTasks: 12,
      completedTasks: 5,
    ),
  ];

  final List<Task> _tasks = [
    Task(
      id: 'task_001',
      title: 'Implement user authentication',
      description: 'Add secure login and registration functionality with JWT tokens',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      assignees: [
        TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'feature', name: 'Feature', color: '#10B981'),
      ],
      createdAt: DateTime(2024, 10, 1),
      dueDate: DateTime(2024, 10, 15),
      projectId: 'proj_001',
      projectName: 'WorkforceOS Mobile',
      createdById: 'emp_004',
      createdByName: 'Sarah Connor',
      estimatedHours: 16.0,
      actualHours: 12.5,
      comments: [
        TaskComment(
          id: 'comment_001',
          taskId: 'task_001',
          authorId: 'emp_001',
          authorName: 'John Doe',
          content: 'Working on JWT implementation. Need to review security best practices.',
          createdAt: DateTime(2024, 10, 5),
        ),
        TaskComment(
          id: 'comment_002',
          taskId: 'task_001',
          authorId: 'emp_004',
          authorName: 'Sarah Connor',
          content: 'Please ensure password hashing is properly implemented.',
          createdAt: DateTime(2024, 10, 6),
        ),
      ],
    ),
    Task(
      id: 'task_002',
      title: 'Design employee dashboard UI',
      description: 'Create wireframes and prototypes for the employee dashboard interface',
      status: TaskStatus.review,
      priority: TaskPriority.medium,
      assignees: [
        TaskAssignee(id: 'emp_002', name: 'Jane Smith', email: 'jane.smith@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'enhancement', name: 'Enhancement', color: '#3B82F6'),
      ],
      createdAt: DateTime(2024, 9, 25),
      dueDate: DateTime(2024, 10, 10),
      projectId: 'proj_001',
      projectName: 'WorkforceOS Mobile',
      createdById: 'emp_004',
      createdByName: 'Sarah Connor',
      estimatedHours: 8.0,
      actualHours: 8.0,
      comments: [
        TaskComment(
          id: 'comment_003',
          taskId: 'task_002',
          authorId: 'emp_002',
          authorName: 'Jane Smith',
          content: 'Initial designs completed. Ready for review.',
          createdAt: DateTime(2024, 10, 8),
        ),
      ],
    ),
    Task(
      id: 'task_003',
      title: 'Fix login validation bug',
      description: 'Users can bypass email validation on login form',
      status: TaskStatus.todo,
      priority: TaskPriority.urgent,
      assignees: [
        TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
        TaskAssignee(id: 'emp_003', name: 'Mike Johnson', email: 'mike.johnson@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'bug', name: 'Bug', color: '#EF4444'),
        TaskLabel(id: 'urgent', name: 'Urgent', color: '#F59E0B'),
      ],
      createdAt: DateTime(2024, 10, 8),
      dueDate: DateTime(2024, 10, 9), // Overdue
      projectId: 'proj_001',
      projectName: 'WorkforceOS Mobile',
      createdById: 'emp_004',
      createdByName: 'Sarah Connor',
      estimatedHours: 4.0,
    ),
    Task(
      id: 'task_004',
      title: 'Setup CI/CD pipeline',
      description: 'Configure automated testing and deployment pipeline',
      status: TaskStatus.done,
      priority: TaskPriority.high,
      assignees: [
        TaskAssignee(id: 'emp_003', name: 'Mike Johnson', email: 'mike.johnson@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'enhancement', name: 'Enhancement', color: '#3B82F6'),
      ],
      createdAt: DateTime(2024, 9, 15),
      dueDate: DateTime(2024, 9, 30),
      completedAt: DateTime(2024, 9, 28),
      projectId: 'proj_002',
      projectName: 'HR Dashboard',
      createdById: 'emp_004',
      createdByName: 'Sarah Connor',
      estimatedHours: 12.0,
      actualHours: 14.0,
    ),
    Task(
      id: 'task_005',
      title: 'Create payroll calculation module',
      description: 'Implement salary calculation with taxes and deductions',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      assignees: [
        TaskAssignee(id: 'emp_001', name: 'John Doe', email: 'john.doe@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'feature', name: 'Feature', color: '#10B981'),
      ],
      createdAt: DateTime(2024, 10, 3),
      dueDate: DateTime(2024, 10, 20),
      projectId: 'proj_003',
      projectName: 'Payroll System',
      createdById: 'emp_004',
      createdByName: 'Sarah Connor',
      estimatedHours: 20.0,
      actualHours: 8.0,
    ),
    Task(
      id: 'task_006',
      title: 'Update API documentation',
      description: 'Update REST API documentation with new endpoints',
      status: TaskStatus.todo,
      priority: TaskPriority.low,
      assignees: [
        TaskAssignee(id: 'emp_002', name: 'Jane Smith', email: 'jane.smith@workforce.com'),
      ],
      labels: [
        TaskLabel(id: 'documentation', name: 'Documentation', color: '#8B5CF6'),
      ],
      createdAt: DateTime(2024, 10, 5),
      dueDate: DateTime(2024, 10, 25),
      projectId: 'proj_002',
      projectName: 'HR Dashboard',
      createdById: 'emp_003',
      createdByName: 'Mike Johnson',
      estimatedHours: 6.0,
    ),
  ];

  Future<List<Task>> getTasks({
    String? projectId,
    String? assigneeId,
    TaskStatus? status,
    TaskPriority? priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filteredTasks = List<Task>.from(_tasks);
    
    if (projectId != null) {
      filteredTasks = filteredTasks.where((task) => task.projectId == projectId).toList();
    }
    
    if (assigneeId != null) {
      filteredTasks = filteredTasks.where((task) => 
        task.assignees.any((assignee) => assignee.id == assigneeId)
      ).toList();
    }
    
    if (status != null) {
      filteredTasks = filteredTasks.where((task) => task.status == status).toList();
    }
    
    if (priority != null) {
      filteredTasks = filteredTasks.where((task) => task.priority == priority).toList();
    }
    
    return filteredTasks;
  }

  Future<Task?> getTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.where((task) => task.id == taskId).firstOrNull;
  }

  Future<List<Project>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_projects);
  }

  Future<Project?> getProject(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _projects.where((project) => project.id == projectId).firstOrNull;
  }

  Future<List<TaskAssignee>> getAssignees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_assignees);
  }

  Future<List<TaskLabel>> getLabels() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_labels);
  }

  Future<Task> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    final task = _tasks[taskIndex];
    final updatedTask = task.copyWith(
      status: newStatus,
      completedAt: newStatus == TaskStatus.done ? DateTime.now() : null,
    );
    
    _tasks[taskIndex] = updatedTask;
    return updatedTask;
  }

  Future<Task> createTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _tasks.add(task);
    return task;
  }

  Future<Task> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    _tasks[taskIndex] = task;
    return task;
  }

  Future<void> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.removeWhere((task) => task.id == taskId);
  }

  Future<TaskStatistics> getTaskStatistics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final totalTasks = _tasks.length;
    final todoTasks = _tasks.where((task) => task.status == TaskStatus.todo).length;
    final inProgressTasks = _tasks.where((task) => task.status == TaskStatus.inProgress).length;
    final reviewTasks = _tasks.where((task) => task.status == TaskStatus.review).length;
    final doneTasks = _tasks.where((task) => task.status == TaskStatus.done).length;
    final overdueTasks = _tasks.where((task) => task.isOverdue).length;
    
    final completedTasks = _tasks.where((task) => 
      task.status == TaskStatus.done && 
      task.completedAt != null
    ).toList();
    
    double averageCompletionTime = 0.0;
    if (completedTasks.isNotEmpty) {
      final totalDays = completedTasks.fold(0.0, (sum, task) {
        final duration = task.completedAt!.difference(task.createdAt);
        return sum + duration.inDays;
      });
      averageCompletionTime = totalDays / completedTasks.length;
    }
    
    return TaskStatistics(
      totalTasks: totalTasks,
      todoTasks: todoTasks,
      inProgressTasks: inProgressTasks,
      reviewTasks: reviewTasks,
      doneTasks: doneTasks,
      overdueTasks: overdueTasks,
      averageCompletionTime: averageCompletionTime,
    );
  }

  Future<TaskComment> addComment(String taskId, String content, String authorId, String authorName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final comment = TaskComment(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      taskId: taskId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
    );
    
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final updatedComments = List<TaskComment>.from(task.comments)..add(comment);
      _tasks[taskIndex] = task.copyWith(comments: updatedComments);
    }
    
    return comment;
  }
}