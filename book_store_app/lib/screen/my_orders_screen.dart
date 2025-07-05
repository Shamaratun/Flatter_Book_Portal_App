import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/OrderResponse.dart';
import '../services/order_history_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<List<OrderResponseDto>> _orders;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final userIdStr = await _secureStorage.read(key: "user_id");
    if (userIdStr != null) {
      final userId = int.parse(userIdStr);
      setState(() {
        _orders = OrderService().getAllOrdersByMe(userId);
      });
    } else {
      setState(() {
        _orders = OrderService().getAllOrdersByMe(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder<List<OrderResponseDto>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          final orderItems = snapshot.data!;

          return ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final orderItem = orderItems[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    "Order #${orderItem.orderId} - \$${orderItem.orderPrice}",
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${orderItem.orderStatus}"),
                      Text("Date: ${orderItem.createdAt}"),
                      Text("Address: ${orderItem.userAddress}"),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrdersScreen()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
