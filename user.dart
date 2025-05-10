import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime lastActive;

  User({
    String? id,
    required this.username,
    required this.password,
    required this.email,
    this.avatar,
    DateTime? createdAt,
    DateTime? lastActive,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastActive = lastActive ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      avatar: map['avatar'],
      createdAt: DateTime.parse(map['createdAt']),
      lastActive: DateTime.parse(map['lastActive']),
    );
  }
}
