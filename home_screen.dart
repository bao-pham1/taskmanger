import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../db/database_helper.dart';
import 'task_form_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _selectedStatus = 'Tất cả';
  final List<String> _statuses = [
    'Tất cả',
    'Chưa làm',
    'Đang làm',
    'Hoàn thành',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await DatabaseHelper.instance.getAllTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(
        completed: !task.completed,
        status: !task.completed ? 'Hoàn thành' : 'Chưa làm',
      );
      await DatabaseHelper.instance.updateTask(updatedTask);
      _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await DatabaseHelper.instance.deleteTask(task.id);
      _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã xóa công việc')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    }
  }

  List<Task> get _filteredTasks {
    if (_selectedStatus == 'Tất cả') return _tasks;
    return _tasks.where((task) => task.status == _selectedStatus).toList();
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Công Việc',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(userId: '1'),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTasks),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _statuses.map((status) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: _selectedStatus == status,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedStatus = status);
                            }
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredTasks.isEmpty
                    ? Center(
                      child: Text(
                        'Không tìm thấy công việc nào',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              task.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    decoration: task.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(task.priority),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Độ ưu tiên ${task.priority}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        task.status,
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskFormScreen(task: task),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadTasks();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Xác Nhận'),
                                          content: const Text('Bạn có chắc chắn muốn xóa công việc này không?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text('Hủy'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text('Xóa'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      _deleteTask(task);
                                    }
                                  },
                                ),
                                Checkbox(
                                  value: task.completed,
                                  onChanged: (value) {
                                    _toggleTaskCompletion(task);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: null, // Removed the bottom navigation bar
    );
  }
}
