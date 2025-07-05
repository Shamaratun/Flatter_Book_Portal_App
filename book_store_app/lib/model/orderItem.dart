import 'dart:core';
import 'OrderItemDto.dart';
import 'book.dart';
import 'enum.dart';
import 'order.dart';

class OrderItem {
  final int? id;
  final String userName;
  final String userAddress;
  final String userPhone;
  final OrderStatus orderStatus;
  final Order order;
  final Book book;
  final int quantity;
  final double orderPrice;
  final List<OrderItemDto> items;
  final String? createdAt;

  OrderItem({
    this.id,
    required this.userName,
    required this.userAddress,
    required this.userPhone,
    required this.orderStatus,
    required this.order,
    required this.book,
    required this.quantity,
    required this.orderPrice,
    required this.items,
     this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      userName: json['userName'],
      userAddress: json['userAddress'],
      userPhone: json['userPhone'],
      quantity: json['quantity'],
      orderPrice: (json['orderPrice'] as num).toDouble(),
      orderStatus: OrderStatus.values.firstWhere((e) =>
      e.name == json['orderStatus']),
      book: Book.fromJson(json['book']),
      // <- Must be present in backend response
      order: Order.fromJson(json['order']),
      // <- optional
      createdAt: json['createdAt'],
      items: (json['items'] as List<dynamic>?)?.map((e) =>
          OrderItemDto.fromJson(e)).toList() ?? [],
    );
  }
}
