class User {
  final int? id;
  final String name;
  final String email;
  final String password; // Optional since it's usually ignored or hidden
  final String role;
  final String? phoneNumber;
  final String? address;
  final String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phoneNumber,
    this.address,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt,
    };
  }
}
