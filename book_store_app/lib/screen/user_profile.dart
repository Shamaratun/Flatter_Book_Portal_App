import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'edit_user_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();



  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    setState(() => _isLoading = true);
    final userIdStr = await _secureStorage.read(key: "user_id");

    final url = Uri.parse('http://10.0.2.2:8082/api/user/get/my/info?id=$userIdStr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _userData = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${response.statusCode}')),
      );
    }

    setState(() => _isLoading = false);
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('No user data found.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildInfoTile("Name", _userData!['name'] ?? '', Icons.person),
            _buildInfoTile("Email", _userData!['email'] ?? '', Icons.email),
            _buildInfoTile("Phone", _userData!['phoneNumber'] ?? 'N/A', Icons.phone),
            _buildInfoTile("Address", _userData!['address'] ?? 'N/A', Icons.home),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserProfileScreen(userId: widget.userId),
                ),
              ).then((_) => _fetchUserInfo()); // Refresh after editing
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
          ),
        ),
          ],
        ),
      ),
    );
  }
}