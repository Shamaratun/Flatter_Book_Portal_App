import 'package:book_store_app/screen/my_orders_screen.dart';
import 'package:book_store_app/screen/register_screen.dart';
import 'package:book_store_app/screen/resources_screen.dart';
import 'package:book_store_app/screen/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'booklist_screen.dart';
import 'cart_screen.dart';
import 'favourite_screen.dart';
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
            const UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("example@gmail.com"),
              currentAccountPicture: CircleAvatar(

                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book_online_outlined),
              title: const Text('Books'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.offline_pin_outlined),
              title: const Text('My Ordered List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersScreen(),

                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.grey),
              title: const Text('Favourite'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouriteScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('My Profile'),
              onTap: () async {
                final storage = const FlutterSecureStorage();
                String? userIdString = await storage.read(key: 'user_id');
                if (userIdString != null) {
                  int userId = int.parse(userIdString);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileScreen(userId: userId )),
                  );
                } else {
                  // handle no userId found, maybe show an error or logout user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User ID not found, please login again.')),
                  );
                  // Optionally navigate to login screen
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      body: const BookListScreen(),
    );
  }
}
