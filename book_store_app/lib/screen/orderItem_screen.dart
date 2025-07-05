import 'package:flutter/material.dart';
import '../model/orderItem.dart';
import '../services/orderItem_service.dart';

class OrderitemScreen extends StatefulWidget {
  const OrderitemScreen({super.key});

  @override
  State<OrderitemScreen> createState() => _OrderitemScreenState();
}

class _OrderitemScreenState extends State<OrderitemScreen> {
  final OrderItemService _orderItemService = OrderItemService();
  late Future<List<OrderItem>> _futureOrderItems;

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  void _loadOrderItems() {
    setState(() {
      _futureOrderItems = _orderItemService.getAllOrderItems();
    });
  }

  Future<void> _confirmAndDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Order Item'),
        content: const Text('Are you sure you want to delete this order item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _orderItemService.removeItem(id);
        setState(() {
          _loadOrderItems();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order item removed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order List Management')),
      body: FutureBuilder<List<OrderItem>>(
        future: _futureOrderItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orderItems = snapshot.data!;

          return ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final orderItem = orderItems[index];
              final book = orderItem.book;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${orderItem.order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: book.bookImageUrl != null
                                ? Image.network(
                              "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                              width: 60,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.book, size: 60),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.bookName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                Text("Author: ${book.authorNames.join(', ')}"),
                                Text('Book ID: ${book.id}'),
                                Text('Quantity: ${orderItem.quantity}'),
                                Text('Price: ৳${orderItem.orderPrice.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmAndDelete(orderItem.id!),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
