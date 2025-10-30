class Branch {
  final int id;
  final String name;
  final String branchAddress;
  final String contactNumber;
  final String coOrdinates;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;

  Branch({
    required this.id,
    required this.name,
    required this.branchAddress,
    required this.contactNumber,
    required this.coOrdinates,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      branchAddress: json['branch_address'],
      contactNumber: json['contact_number'],
      coOrdinates: json['co_ordinates'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
    );
  }
}
