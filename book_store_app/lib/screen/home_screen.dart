import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'booklist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Store App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white10, fontSize: 30),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Book'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookListScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: const Center(child: Text('Welcome to Bookshop app!')),
    );
  }
}
