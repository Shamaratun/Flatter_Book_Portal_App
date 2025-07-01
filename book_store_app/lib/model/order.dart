class Order {
  final int?id;
  final double orderPrice;
  final String address;
  final String contact;

  //
  // final OrderStatus orderStatus;
  // final Set<OrderItem> orderItems = new HashSet<>();
  // final Set<OrderItem> orderItems = new HashSet<>();

  Order({this.id,
    required this.orderPrice,
    required this.address,
    required this.contact
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      address: json['address'] as String? ?? '',
      orderPrice: (json['orderPrice'] as num?)?.toDouble() ?? 0.0,
      contact: json['contact'] as String? ?? '',

      // bookImageUrl: json['bookImageUrl'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'orderPrice': [orderPrice],
      'contact': [contact],
      // 'bookIsbnNumber': [bookIsbnNumber],
    };
  }
}