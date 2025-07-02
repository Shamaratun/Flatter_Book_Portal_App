import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final AuthService _authService = AuthService();
  Map<String, String> _resources = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchResources();
  }

  Future<void> _fetchResources() async {
    try {
      final response = await _authService.makeAuthenticatedRequest(
        method: 'GET',
        endpoint: '/api/secured/resources',
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _resources = data.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load resources: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _resources.isEmpty
          ? const Center(child: Text('No resources found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _resources.length,
              itemBuilder: (context, index) {
                final key = _resources.keys.elementAt(index);
                final value = _resources[key];
                return ListTile(title: Text(key), subtitle: Text(value!));
              },
            ),
    );
  }
}
