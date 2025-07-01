import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';
import '../model/orderItem.dart';
import '../services/orderItem_service.dart';

class OrderitemScreen extends StatefulWidget {
  const OrderitemScreen({super.key});

  @override
  State<OrderitemScreen> createState() => _OrderitemScreenState();
}

class _OrderitemScreenState extends State<OrderitemScreen> {
  final OrderItemService _orderItemService = OrderItemService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(' OrderList Management')),
        body: FutureBuilder<List<OrderItem>>(
        future: _orderItemService.getAllOrderItems(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(child: Text('No order found'));
    }
    final orderItems = snapshot.data!;
    return ListView.builder(
    itemCount: orderItems.length,
    itemBuilder: (context, index) {
    final orderItem = orderItems[index];
    return ListTile(
    leading:
    const Icon(Icons.book_online_outlined),
    title: Text(orderItem.id?.toString() ?? 'No ID'),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(orderItem.book.bookName), // Assuming book has a title
    Text('Order ID: ${orderItem.order.id}'), // Assuming order has an ID
    Text('Book IDs: ${orderItem.bookIds.join(', ')}'),
    Text('Quantity: ${orderItem.quantity.toString()}'),
    Text('৳${orderItem.itemPrice.toStringAsFixed(2)}'),
    ],
    ),
    trailing: IconButton(
    icon: const Icon(Icons.add_card_sharp),
    onPressed: () async {
    try {
    await _orderItemService.removeItem(orderItem.id!);
    setState(() {});
    } catch (e) {
    ScaffoldMessenger.of(
    context,
    ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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