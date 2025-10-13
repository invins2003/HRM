// lib/module/expense/model/expense_model.dart
class ExpenseResponse {
  bool success;
  List<Expense> data;

  ExpenseResponse({required this.success, required this.data});

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<Expense>.from(json['data'].map((x) => Expense.fromJson(x)))
          : [],
    );
  }
}

class Expense {
  int id;
  int branchId;
  String paymentDate;
  double subtotal;
  double taxTotal;
  double totalAmount;
  String paymentsStatus;
  int createdBy;
  int? categoryId;
  String description;
  String? document;
  bool isDeleted;
  String createdAt;
  String updatedAt;
  Creator creator;
  Branch branch;

  Expense({
    required this.id,
    required this.branchId,
    required this.paymentDate,
    required this.subtotal,
    required this.taxTotal,
    required this.totalAmount,
    required this.paymentsStatus,
    required this.createdBy,
    this.categoryId,
    required this.description,
    this.document,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.creator,
    required this.branch,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      branchId: json['branch_id'],
      paymentDate: json['payment_date'],
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      taxTotal: double.tryParse(json['tax_total'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      paymentsStatus: json['payments_status'],
      createdBy: json['created_by'],
      categoryId: json['category_id'],
      description: json['description'] ?? '',
      document: json['document'],
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      creator: Creator.fromJson(json['creator']),
      branch: Branch.fromJson(json['branch']),
    );
  }
}

class Creator {
  int id;
  String name;

  Creator({required this.id, required this.name});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(id: json['id'], name: json['name']);
  }
}

class Branch {
  int id;
  String name;

  Branch({required this.id, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(id: json['id'], name: json['name']);
  }
}
