class ExpenseModel {
  bool? success;
  String? message;
  ExpenseData? data;

  ExpenseModel({this.success, this.message, this.data});

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ExpenseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class ExpenseData {
  int? id;
  String? description;
  double? amount;
  double? taxRate;
  bool? isTaxable;
  String? documentUrl;

  ExpenseData({
    this.id,
    this.description,
    this.amount,
    this.taxRate,
    this.isTaxable,
    this.documentUrl,
  });

  ExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'] != null ? json['amount'].toDouble() : null;
    taxRate = json['tax_rate'] != null ? json['tax_rate'].toDouble() : null;
    isTaxable = json['is_taxable'];
    documentUrl = json['document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['description'] = description;
    map['amount'] = amount;
    map['tax_rate'] = taxRate;
    map['is_taxable'] = isTaxable;
    map['document'] = documentUrl;
    return map;
  }
}
