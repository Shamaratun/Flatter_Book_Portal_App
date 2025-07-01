class Book {
  final int? id;
  final String bookName;
  final String authorName;
  final int bookIsbnNumber;
  final double bookPrice;
  final double bookRating;
  final String bookCategory;
  final String? bookImageUrl;
  final int bookQuantity;
  final String bookDescription;
  final String createdAt;
  final List<String> authorNames;

  Book({
    this.id,
    required this.authorName,
    required this.bookName,
    required this.bookIsbnNumber,
    required this.bookPrice,
    required this.bookRating,
    required this.bookCategory,
    required this.bookImageUrl,
    required this.bookQuantity,
    required this.bookDescription,
    required this.createdAt,
    required this.authorNames,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      bookName: json['bookName'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      bookIsbnNumber: json['bookIsbnNumber'] as int? ?? 0,
      bookPrice: (json['bookPrice'] as num?)?.toDouble() ?? 0.0,
      bookRating: (json['bookRating'] as num?)?.toDouble() ?? 0.0,
      bookCategory: json['bookCategory'] as String? ?? '',
      bookQuantity: json['bookQuantity'] as int? ?? 0,
      bookDescription: json['bookDescription'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      bookImageUrl: json['bookImageUrl'] as String?,
      authorNames: List<String>.from(json['authorNames'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'bookIsbnNumber': bookIsbnNumber,
      'bookPrice': bookPrice,
      'bookRating': bookRating,
      'bookCategory': bookCategory,
      'bookImageUrl': bookImageUrl,
      'bookQuantity': bookQuantity,
      'bookDescription': bookDescription,
      'createdAt': createdAt,
    };
  }
}
