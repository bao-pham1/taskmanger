import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('taskmanager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT,
        createdAt TEXT NOT NULL,
        lastActive TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        priority INTEGER NOT NULL,
        dueDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        assignedTo TEXT,
        createdBy TEXT NOT NULL,
        category TEXT,
        attachments TEXT,
        completed INTEGER NOT NULL
      )
    ''');

    // Insert default admin user
    await db.insert('users', {
      'id': '1',
      'username': 'admin',
      'password': 'admin',
      'email': 'admin@example.com',
      'createdAt': DateTime.now().toIso8601String(),
      'lastActive': DateTime.now().toIso8601String(),
    });
  }

  // User operations
  Future<String> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
    return user.id;
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Task operations
  Future<String> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
    return task.id;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<List<Task>> getTasksByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'createdBy = ? OR assignedTo = ?',
      whereArgs: [userId, userId],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> searchTasks(String query) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'status = ?',
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<List<Task>> getTasksByPriority(int priority) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }
}
