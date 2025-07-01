// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import '../model/orderItem.dart';
// class BookService {
// static const String baseUrl ='http://192.168.100.21:8082';
//
//
// Future<List<OrderItem>> getAllOrderItems() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/api/user/get/all/orderItems'),
//   );
//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((json) => OrderItem.fromJson(json)).toList();
//   } else {
//     throw Exception("failed to load orderItems");
//   }
// }
//
// Future<OrderItem> getAllOrderItemById() async {
//   final response = await http.get(Uri.parse('$baseUrl/book'));
//   if (response.statusCode == 200) {
//     return OrderItem.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception("failed to load OrderItems");
//   }
// }
//
// Future<Book> saveBook(Book book) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/book'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(book.toJson()),
//   );
//   if (response.statusCode == 200) {
//     return Book.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception("failed to save book");
//   }
// }
//
// Future<Book> updateBook(int id, Book book) async {
//   final response = await http.put(
//     Uri.parse('$baseUrl/book/$id'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(book.toJson()),
//   );
//   if (response.statusCode == 200) {
//     return Book.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception("failed to update book");
//   }
// }
//
// Future<void> deleteBook(int id) async {
//   final response = await http.delete(Uri.parse('$baseUrl/book/$id'));
//   if (response.statusCode != 200) {
//     throw Exception("failed to delete book");
//   }
// }
// Future<void> BookAddToCart(int id) async {
//   final response = await http.delete(Uri.parse('$baseUrl/book/$id'));
//   if (response.statusCode != 200) {
//     throw Exception("failed to add in cart ");
//   }
// }
// }
