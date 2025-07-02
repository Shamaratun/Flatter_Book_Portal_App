class Author {
  final int? id;
  final String authorName;
  final int authorNid;
  final String authorBio;
  final String address;

  Author({
    this.id,
    required this.authorName,
    required this.authorNid,
    required this.authorBio,
    required this.address,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      authorName: json['authorName'],
      authorNid: json['authorNid'],
      authorBio: json['authorBio'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorNid': authorNid,
      'authorBio': authorBio,
      'address': address,
    };
  }
}
