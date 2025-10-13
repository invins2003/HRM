class ExpenseCategory {
  final int id;
  final String name;
  final int createdBy;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'] ?? '',
      createdBy: json['created_by'] ?? 0,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

