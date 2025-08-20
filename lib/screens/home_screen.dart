import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';
import '../models/task.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? _taskError;

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildAddTaskSection(),
              const SizedBox(height: 24),
              _buildSearchSection(),
              const SizedBox(height: 16),
              _buildFilterChips(),
              const SizedBox(height: 24),
              Expanded(child: _buildTaskList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDark),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Consumer<TaskService>(
      builder: (context, taskService) {
        final progress = taskService.allTasks.isEmpty
            ? 0.0
            : taskService.completedTaskCount / taskService.allTasks.length;

        return Row(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${taskService.completedTaskCount}/${taskService.allTasks.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                'PocketTasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            _buildThemeToggle(),
          ],
        );
      },
    );
  }

  Widget _buildAddTaskSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'Add Task',
                    border: InputBorder.none,
                    errorText: _taskError,
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          final taskService = ChangeNotifierProvider.of<TaskService>(context);
          taskService.setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<TaskService>(
      builder: (context, taskService) {
        return Row(
          children: [
            _buildFilterChip('All', TaskFilter.all, taskService),
            const SizedBox(width: 8),
            _buildFilterChip('Active', TaskFilter.active, taskService),
            const SizedBox(width: 8),
            _buildFilterChip('Done', TaskFilter.done, taskService),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, TaskFilter filter, TaskService taskService) {
    final isSelected = taskService.currentFilter == filter;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => taskService.setFilter(filter),
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        elevation: isSelected ? 2 : 0,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskService>(
      builder: (context, taskService) {
        final tasks = taskService.filteredTasks;

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  taskService.searchQuery.isNotEmpty
                      ? 'No tasks found'
                      : 'No tasks yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return TaskTile(
              task: task,
              onToggle: () => _toggleTask(task),
              onDelete: () => _deleteTask(task),
            );
          },
        );
      },
    );
  }

  void _addTask() {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      setState(() {
        _taskError = 'Task title cannot be empty';
      });
      return;
    }

    setState(() {
      _taskError = null;
    });

    final taskService = ChangeNotifierProvider.of<TaskService>(context);
    taskService.addTask(title);
    _taskController.clear();
  }

  void _toggleTask(Task task) {
    final taskService = ChangeNotifierProvider.of<TaskService>(context);
    taskService.toggleTask(task.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(task.done ? 'Task marked as active' : 'Task completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => taskService.toggleTask(task.id),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _deleteTask(Task task) {
    final taskService = ChangeNotifierProvider.of<TaskService>(context);
    taskService.deleteTask(task.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => taskService.restoreTask(task),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}