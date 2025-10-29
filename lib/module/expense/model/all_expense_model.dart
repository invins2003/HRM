// lib/module/expense/model/expense_model.dart
class ExpenseResponse {
  bool? success;
  List<Expense>? data;

  ExpenseResponse({this.success, this.data});

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      success: json['success'],
      data: json['data'] != null
          ? List<Expense>.from(json['data'].map((x) => Expense.fromJson(x)))
          : null,
    );
  }
}

class Expense {
  int? id;
  int? branchId;
  int? employeeId;
  String? paymentDate;
  double? subtotal;
  double? taxTotal;
  double? totalAmount;
  String? paymentsStatus;
  String? paymentStatus;
  int? createdBy;
  int? categoryId;
  String? description;
  String? document;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  Creator? creator;
  Branch? branch;
  List<Item>? items;
  String? vendorname;
  String? typeOfSupplOrService;

  Expense({
    this.id,
    this.branchId,
    this.employeeId,
    this.paymentDate,
    this.subtotal,
    this.taxTotal,
    this.vendorname,
    this.typeOfSupplOrService,
    this.totalAmount,
    this.paymentsStatus,
    this.paymentStatus,
    this.createdBy,
    this.categoryId,
    this.description,
    this.document,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.creator,
    this.branch,
    this.items,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      branchId: json['branch_id'],
      employeeId: json['employee_id'],
      vendorname: json['vendor_name'],
      typeOfSupplOrService: json['type_of_supply_or_service'],
      paymentDate: json['payment_date'],
      subtotal: json['subtotal'] != null ? double.tryParse(json['subtotal'].toString()) : null,
      taxTotal: json['tax_total'] != null ? double.tryParse(json['tax_total'].toString()) : null,
      totalAmount: json['total_amount'] != null ? double.tryParse(json['total_amount'].toString()) : null,
      paymentsStatus: json['payments_status'],
      paymentStatus: json['payment_status'],      
      createdBy: json['created_by'],
      categoryId: json['category_id'],
      description: json['description'],
      document: json['document'],

      isDeleted: json['is_deleted'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      creator: json['creator'] != null ? Creator.fromJson(json['creator']) : null,
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      items: json['items'] != null
          ? List<Item>.from(json['items'].map((x) => Item.fromJson(x)))
          : null,
    );
  }
}

class Creator {
  int? id;
  String? name;

  Creator({this.id, this.name});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Branch {
  int? id;
  String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Item {
  int? id;
  int? expenseId;
  String? itemName;
  double? subtotal;
  bool? isTaxable;
  double? taxRate;
  String? taxType;
  double? taxTotal;
  double? totalAmount;
  String? document;
  String? createdAt;
  String? updatedAt;
  String? paymentDate;

  Item({
    this.id,
    this.expenseId,
    this.itemName,
    this.subtotal,
    this.isTaxable,
    this.taxRate,
    this.taxType,
    this.taxTotal,
    this.totalAmount,
    this.document,
    this.createdAt,
    this.updatedAt,
    this.paymentDate
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      expenseId: json['expense_id'],
      itemName: json['item_name'],
      subtotal: json['subtotal'] != null ? double.tryParse(json['subtotal'].toString()) : null,
      isTaxable: json['is_taxable'],
      taxRate: json['tax_rate'] != null ? double.tryParse(json['tax_rate'].toString()) : null,
      taxType: json['tax_type'],
      taxTotal: json['tax_total'] != null ? double.tryParse(json['tax_total'].toString()) : null,
      totalAmount: json['total_amount'] != null ? double.tryParse(json['total_amount'].toString()) : null,
      document: json['document'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      paymentDate: json["payment_date"]
    );
  }
}
