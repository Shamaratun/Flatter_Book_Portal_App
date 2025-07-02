import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/order.dart';
import '../model/orderItem.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> Order = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Order.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Order.length,
                itemBuilder: (context, index) {
                  final item = Order[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['bookName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price: BDT ${item['bookPrice']}"),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => decreaseQuantity(item['id']),
                              ),
                              Text("${item['quantity']}"),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => increaseQuantity(item['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "Subtotal: BDT ${item['bookPrice'] * item['quantity']}"),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeFromCart(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: BDT $totalPrice",
                    style: TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: openOrderModal,
                  child: Text("Place Order"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
