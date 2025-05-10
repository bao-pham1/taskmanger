import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';

class TaskListScreen extends StatelessWidget {
  final List<String> tasks = ["Task 1", "Task 2", "Task 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Công Việc'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task),
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
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
                return confirm ?? false;
              }
              return false;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Xử lý xóa công việc
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$task đã bị xóa')),
                );
              }
            },
            child: ListTile(
              title: Text(task),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Xử lý chỉnh sửa công việc
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Chỉnh sửa $task')),
                      );
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
                      if (confirm ?? false) {
                        // Xử lý xóa công việc
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$task đã bị xóa')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Công Việc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on system settings
      home: const OnboardingPage1(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// Fixing the use of BuildContext across async gaps
Future<void> someAsyncFunction(BuildContext context) async {
  // Simulate an async operation
  await Future.delayed(const Duration(seconds: 1));

  if (!context.mounted) return; // Ensure the context is still valid

  // Use the context safely here
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
