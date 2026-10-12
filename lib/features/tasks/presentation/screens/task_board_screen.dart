import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../data/task_repository.dart';
import '../../domain/task_models.dart';
import '../widgets/task_card.dart';
import '../widgets/task_status_column.dart';
import '../widgets/task_detail_modal.dart';
import '../widgets/task_filter_bar.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen>
    with TickerProviderStateMixin {
  final _repository = MockTaskRepository();
  late TabController _tabController;

  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedProjectId;
  TaskPriority? _selectedPriority;

  final List<TaskStatus> _statuses = [
    TaskStatus.todo,
    TaskStatus.inProgress,
    TaskStatus.review,
    TaskStatus.done,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final tasks = await _repository.getTasks();

      if (mounted) {
        setState(() {
          _allTasks = tasks;
          _filteredTasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTasks = _allTasks.where((task) {
        bool matchesProject = _selectedProjectId == null || 
                            task.projectId == _selectedProjectId;
        bool matchesPriority = _selectedPriority == null || 
                             task.priority == _selectedPriority;
        return matchesProject && matchesPriority;
      }).toList();
    });
  }

  Future<void> _showTaskDetail(Task task) async {
    final result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailModal(task: task),
    );

    if (result != null) {
      // Refresh tasks if task was updated
      _loadTasks();
    }
  }

  Future<void> _updateTaskStatus(Task task, TaskStatus newStatus) async {
    try {
      await _repository.updateTaskStatus(task.id, newStatus);
      _loadTasks(); // Refresh the task list
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task moved to ${newStatus.name}'),
            backgroundColor: AppTheme.basari,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidyen,
      appBar: AppBar(
        title: Text(
          'Task Board',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.obsidyen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.buz),
        actions: [
          IconButton(
            onPressed: _loadTasks,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          TaskFilterBar(
            selectedProjectId: _selectedProjectId,
            selectedPriority: _selectedPriority,
            onProjectChanged: (projectId) {
              setState(() {
                _selectedProjectId = projectId;
              });
              _applyFilters();
            },
            onPriorityChanged: (priority) {
              setState(() {
                _selectedPriority = priority;
              });
              _applyFilters();
            },
            onClearFilters: () {
              setState(() {
                _selectedProjectId = null;
                _selectedPriority = null;
              });
              _applyFilters();
            },
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryStart),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load tasks',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadTasks,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedProjectId != null || _selectedPriority != null
                  ? 'Try adjusting your filters'
                  : 'Tasks will appear here once created',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Tab bar for mobile
        Container(
          color: AppTheme.yuzey,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppTheme.primaryStart,
            unselectedLabelColor: AppTheme.soluk,
            indicatorColor: AppTheme.primaryStart,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: _statuses.map((status) {
              final count = _filteredTasks
                  .where((task) => task.status == status)
                  .length;
              return Tab(
                text: '${_getStatusDisplayName(status)} ($count)',
              );
            }).toList(),
          ),
        ),
        
        // Tab view
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _statuses.map((status) {
              final tasks = _filteredTasks
                  .where((task) => task.status == status)
                  .toList();
              return _buildTaskList(tasks, status);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Row(
        children: _statuses.map((status) {
          final tasks = _filteredTasks
              .where((task) => task.status == status)
              .toList();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TaskStatusColumn(
                status: status,
                tasks: tasks,
                onTaskTap: _showTaskDetail,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _statuses.map((status) {
          final tasks = _filteredTasks
              .where((task) => task.status == status)
              .toList();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TaskStatusColumn(
                status: status,
                tasks: tasks,
                onTaskTap: _showTaskDetail,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskStatus status) {
    return RefreshIndicator(
      onRefresh: _loadTasks,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppTheme.spaceMedium),
        itemCount: tasks.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: AppTheme.spaceMedium,
        ),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onTap: () => _showTaskDetail(task),
            onStatusChanged: (newStatus) => _updateTaskStatus(task, newStatus),
          );
        },
      ),
    );
  }

  String _getStatusDisplayName(TaskStatus status) {
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
}