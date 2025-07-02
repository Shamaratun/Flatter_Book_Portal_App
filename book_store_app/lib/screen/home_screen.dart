import 'package:book_store_app/screen/resources_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'booklist_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'orderItem_screen.dart';

class HomeScreen extends StatelessWidget {


  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await const FlutterSecureStorage().delete(key: 'access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   '${user['firstName']} ${user['lastName']}',
                  //   style: const TextStyle(color: Colors.white, fontSize: 24),
                  // ),
                  Text(
                    'email',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Resources'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResourcesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),

            // @override
            // Widget build(BuildContext context) {
            //   return Scaffold(
            //     appBar: AppBar(title: const Text('Book Store App')),
            //     drawer: Drawer(
            //       child: ListView(
            //         padding: EdgeInsets.zero,
            //         children: [
            //           const DrawerHeader(
            //             decoration: BoxDecoration(color: Colors.blue),
            //             child: Text(
            //               'Menu',
            //               style: TextStyle(color: Colors.white10, fontSize: 30),
            //             ),
            //           ),
            ListTile(
              leading: const Icon(Icons.book_online_outlined),
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
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.offline_pin_outlined),
              title: const Text('Order'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderitemScreen(),
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
