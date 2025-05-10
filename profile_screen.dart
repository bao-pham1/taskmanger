import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../db/database_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await DatabaseHelper.instance.getUser(widget.userId);
      setState(() {
        _user = user;
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

  Future<void> _logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tài Khoản',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _user?.avatar != null
                        ? NetworkImage(_user!.avatar!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _user?.username ?? 'Không có tên',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user?.email ?? 'Không có email',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInfoCard('Thông tin tài khoản', [
                    _buildInfoRow('Tên đăng nhập', _user?.username ?? ''),
                    _buildInfoRow('Email', _user?.email ?? ''),
                    _buildInfoRow(
                      'Ngày tạo',
                      _user?.createdAt.toString().split(' ')[0] ?? '',
                    ),
                    _buildInfoRow(
                      'Hoạt động cuối',
                      _user?.lastActive.toString().split(' ')[0] ?? '',
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoCard('Cài Đặt', [
                    SwitchListTile(
                      title: const Text(
                        'Chế Độ Tối',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                      activeColor: Colors.blue.shade900,
                    ),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey[600])),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
