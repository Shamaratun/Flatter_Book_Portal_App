import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/orderItem.dart';
class OrderItemService {
static const String baseUrl ='http://192.168.100.21:8082';


Future<List<OrderItem>> getAllOrderItems() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/user/get/my/all/order'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => OrderItem.fromJson(json)).toList();
  } else {
    throw Exception("failed to load orderItems");
  }
}

Future<OrderItem> getAllOrderItemById() async {
  final response = await http.get(Uri.parse('$baseUrl/orderItem'));
  if (response.statusCode == 200) {
    return OrderItem.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("failed to load OrderItems");
  }
}
  Future<void> removeItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/orderItem/$id'));
    if (response.statusCode != 200) {
      throw Exception("failed to remove orderItem");
    }
  }


}
