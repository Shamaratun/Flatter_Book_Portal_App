import 'package:book_store_app/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/cart_item.dart';
import '../services/book_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final BookService _bookService = BookService();
  final CartService _cartService = CartService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  int _user_id = 1;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });

    int localUserId = 1;
    try {
      final userIdStr = await _secureStorage.read(key: "user_id");
      print("user_id from storage: $userIdStr");
      if (userIdStr != null) {
        localUserId = int.parse(userIdStr);
      }

      final items = await _bookService.getLocalCart();
      print("Loaded cart items: $items");

      setState(() {
        _cartItems = items;
        _user_id = localUserId;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading cart: $e");
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load cart: $e")),
      );
    }
  }

  Future<void> _updateCart() async {
    await _bookService.saveCart(_cartItems);
    setState(() {});
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity += 1;
    });
    _updateCart();
  }

  void _decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      setState(() {
        _cartItems[index].quantity -= 1;
      });
      _updateCart();
    }
  }

  Future<void> _clearCart() async {
    await _bookService.clearLocalCart();
    setState(() {
      _cartItems = [];
    });
  }

  void _removeItem(int index) async {
    setState(() {
      _cartItems.removeAt(index);
    });

    await _bookService.removeItem(index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removed from cart')),
    );
  }

  double get _totalPrice {
    return _cartItems.fold(
      0.0,
          (total, item) => total + item.book.bookPrice * item.quantity,
    );
  }

  void _showEmptyToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cart item is ${_cartItems.length}')),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Checkout'),
        content: Text(
          'Total: ৳${_totalPrice.toStringAsFixed(2)}\nProceed to checkout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              try {
                setState(() {
                  _isLoading = true;
                });

                await _cartService.placeOrderWithoutAddress(
                  userId: _user_id,
                  cartItems: _cartItems,
                );

                setState(() {
                  _cartItems.clear();
                  _isLoading = false;
                });
                _clearCart();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout successful!')),
                );
              } catch (e) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Checkout failed: $e')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Cart',
            onPressed: _cartItems.isNotEmpty ? _clearCart : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                final book = item.book;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: book.bookImageUrl != null
                              ? Image.network(
                            "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) =>
                                Container(
                                  width: 60,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.book),
                                ),
                          )
                              : Container(
                            width: 60,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.bookName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Text("Category: ${book.bookCategory}"),
                              Text(
                                "৳${book.bookPrice.toStringAsFixed(2)} x ${item.quantity} = ৳${(book.bookPrice * item.quantity).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.add_circle_outline),
                              onPressed: () =>
                                  _increaseQuantity(index),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: item.quantity == 1
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                              onPressed: item.quantity > 1
                                  ? () => _decreaseQuantity(index)
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              tooltip: 'Remove item',
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ৳${_totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout'),
                  onPressed: _cartItems.isNotEmpty
                      ? _showCheckoutDialog
                      : _showEmptyToast,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
