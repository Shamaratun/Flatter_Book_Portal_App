import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_item.dart';
import '../model/orderItem.dart';

class CartService {
  static const String baseUrl = 'http://10.0.2.2:8082';

  Future<void> placeOrder({
    required int userId,
    required String address,
    required String contact,
    required List<CartItem> cartItems,
  }) async {
    final List<int> bookIds = cartItems.map((item) => item.book.id!).toList();
    final double totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.book.bookPrice * item.quantity),
    );

    final payload = {
      "userId": userId,
      "address": address,
      "contact": contact,
      "bookIds": bookIds,
      "orderPrice": totalPrice,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/user/order/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to place order: ${response.body}");
    }
  }

  Future<OrderItem> getAllOrderItemById() async {
    final response = await http.get(Uri.parse('$baseUrl/orderItem'));
    if (response.statusCode == 200) {
      return OrderItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load order item");
    }
  }

  Future<void> removeItemfromcart(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/orderItem/$id'));
    if (response.statusCode != 200) {
      throw Exception("Failed to remove order item");
    }
  }

  Future<void> increaseQuantity(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orderItem/increase/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to increase quantity");
    }
  }

  Future<void> decreaseQuantity(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orderItem/decrease/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to decrease quantity");
    }
  }
}
