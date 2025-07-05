class Order {
  final int? id;
  final double orderPrice;
  final String address;
  final String contact;
  final int userId;
  final List<int> bookIds;

  Order({
    this.id,
    required this.orderPrice,
    required this.address,
    required this.contact,
    required this.bookIds,
    required this.userId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      address: json['address'] as String? ?? '',
      orderPrice: (json['orderPrice'] as num?)?.toDouble() ?? 0.0,
      contact: json['contact'] as String? ?? '',
      bookIds: List<int>.from(json['bookIds'] ?? []),
      userId: json['userId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'orderPrice': orderPrice,
      'contact': contact,
      'userId': userId,
      'bookIds': [bookIds],
    };
  }
}
