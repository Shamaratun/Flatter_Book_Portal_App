class OrderResponseDto {
  final int orderId;
  final double orderPrice;
  final String userName;
  final String userAddress;
  final String userPhone;
  final String orderStatus;
  final int userId;
  final List<OrderItemDto> items;
  final String createdAt;

  OrderResponseDto({
    required this.orderId,
    required this.orderPrice,
    required this.userName,
    required this.userAddress,
    required this.userPhone,
    required this.orderStatus,
    required this.userId,
    required this.items,
    required this.createdAt,
  });

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    var itemList = (json['items'] as List)
        .map((item) => OrderItemDto.fromJson(item))
        .toList();

    return OrderResponseDto(
      orderId: json['orderId'],
      orderPrice: (json['orderPrice'] as num).toDouble(),
      userName: json['userName'],
      userAddress: json['userAddress'],
      userPhone: json['userPhone'],
      orderStatus: json['orderStatus'],
      userId: json['userId'],
      items: itemList,
      createdAt: json['createdAt'],
    );
  }
}

class OrderItemDto {
  final String productName;
  final int quantity;
  final double price;

  OrderItemDto({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
    );
  }
}
