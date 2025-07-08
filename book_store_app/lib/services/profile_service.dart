import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8082/api/user';
  final _storage = const FlutterSecureStorage();

  Future<int?> getUserId() async {
    final idStr = await _storage.read(key: 'user_id');
    if (idStr != null) {
      return int.tryParse(idStr);
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
    final userIdStr = await _secureStorage.read(key: "user_id");

    final url = Uri.parse('$_baseUrl/get/my/info?id=$userIdStr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<void> updateUserProfile({
    required int userId,
    required String name,
    required String phoneNo,
    required String address,
  }) async {
    final url = Uri.parse('$_baseUrl/edit/my/info/$userId');
    final body = jsonEncode({
      'name': name,
      'phoneNo': phoneNo,
      'address': address,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }


}