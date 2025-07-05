import 'book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book.fromJson(json['book']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'book': book.toJson(),
    'quantity': quantity,
  };
}
