class UserModel {
  final int id;
  final String name;
  final String email;
  final String type;
  final List<String> permissions;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}
