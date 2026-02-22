class AccessModel {
  final String? id;
  final String name;
  final String? code;
  final String? role;

  AccessModel({
    this.id,
    required this.name,
    this.code,
    this.role,
  });

  factory AccessModel.fromMap(String id, Map<String, dynamic> data) {
    return AccessModel(
      id: id,
      name: data['name'],
      code: data['code'],
      role: data['role'],
    );
  }
}
