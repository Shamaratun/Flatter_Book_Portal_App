// import 'book.dart';
// import 'order.dart';
//
// class OrderItem {
//   final int? id;
//
//   final Order order;
//
//   final Book book;
//
//   final int quantity;
//
//   final double itemPrice;
//
//   OrderItem({
//     this.id,
//     required this.order,
//     required this.book,
//     required this.quantity,
//     required this.itemPrice,
//   });
//
//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       id: json['id'] as int?,
//       order: json['order'] as String? ?? '',
//       book: json['book'] as String? ?? '',
//       itemPrice: (json['itemPrice'] as num?)?.toDouble() ?? 0.0,
//       quantity: json['quantity'] as int? ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'book': [book],
//       'itemPrice': [itemPrice],
//       'quantity': [quantity],
//     };
//   }
// }
