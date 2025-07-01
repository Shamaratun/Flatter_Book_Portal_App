import 'book.dart';
import 'order.dart';

class OrderItem {
  final int? id;

  final Order order;

  final Book book;

  final int quantity;

  final double itemPrice;
  final List< int > bookIds;


  OrderItem({
    this.id,
    required this.order,
    required this.book,
    required this.quantity,
    required this.itemPrice,
    required this.bookIds,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      order: Order.fromJson(json['order']),
      book: Book.fromJson(json['book']),
      itemPrice: (json['itemPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
        bookIds: List<int>.from(json['bookIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order':order,
      'book': book,
      'itemPrice': itemPrice,
      'quantity': quantity,
      'bookIds':[bookIds],
    };
  }
}
