import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'task_storage.dart';

enum TaskFilter { all, active, done }

class TaskService extends ChangeNotifier {
  final TaskStorage _storage = TaskStorage();
  List<Task> _allTasks = [];
  String _searchQuery = '';
  TaskFilter _currentFilter = TaskFilter.all;
  Timer? _searchDebounceTimer;

  // Getters
  List<Task> get allTasks => _allTasks;
  String get searchQuery => _searchQuery;
  TaskFilter get currentFilter => _currentFilter;

  List<Task> get filteredTasks {
    List<Task> filtered = _allTasks;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply status filter
    switch (_currentFilter) {
      case TaskFilter.active:
        filtered = filtered.where((task) => !task.done).toList();
        break;
      case TaskFilter.done:
        filtered = filtered.where((task) => task.done).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  int get activeTaskCount => _allTasks.where((task) => !task.done).length;
  int get completedTaskCount => _allTasks.where((task) => task.done).length;

  // Initialize
  Future<void> initialize() async {
    _allTasks = await _storage.loadTasks();
    notifyListeners();
  }

  // Task operations
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;

    final task = Task(title: title.trim());
    _allTasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _allTasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    _allTasks[taskIndex] = _allTasks[taskIndex].copyWith(done: !_allTasks[taskIndex].done);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _allTasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> restoreTask(Task task) async {
    _allTasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  // Filter operations
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;

    // Debounce search
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  Future<void> _saveTasks() async {
    await _storage.saveTasks(_allTasks);
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}