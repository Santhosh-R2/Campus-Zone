class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? classTeacherId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.classTeacherId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['_id'],
      name: json['name'],
      email: json['email'] ?? '',
      role: json['role'],
      classTeacherId: json['classTeacherId'],
    );
  }
}
