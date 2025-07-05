class OrderItemDto {
  final int bookId;
  final int quantity;

  OrderItemDto({
    required this.bookId,
    required this.quantity});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(bookId: json['bookId'],
        quantity: json['quantity']);
  }
}
