class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  // Mengubah JSON dari Laravel menjadi Object Dart
  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: token,
    );
  }
}
