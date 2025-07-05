import 'dart:convert';

import '../model/OrderResponse.dart';
import 'package:http/http.dart' as http;
class OrderService {
  static const String baseUrl = 'http://10.0.2.2:8082';

  Future<List<OrderResponseDto>> getAllOrdersByMe() async {

    final response = await http.get(Uri.parse('$baseUrl/api/user/get/my/all/order'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => OrderResponseDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }
}