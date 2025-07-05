import 'package:flutter/material.dart';
import '../model/OrderResponse.dart';
import '../services/OrderHistoryService.dart';

class MyOrdersScreen extends StatefulWidget {

  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late Future<List<OrderResponseDto>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = OrderService().getAllOrdersByMe();
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

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Order #${order.orderId} - \$${order.orderPrice}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${order.orderStatus}"),
                      Text("Date: ${order.createdAt}"),
                      Text("Address: ${order.userAddress}"),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Optional: Navigate to order detail screen
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
