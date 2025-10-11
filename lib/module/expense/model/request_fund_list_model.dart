// lib/module/expense/model/fund_request_list_model.dart
class FundRequestListModel {
  bool? success;
  List<FundRequestData>? data;

  FundRequestListModel({this.success, this.data});

  FundRequestListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <FundRequestData>[];
      json['data'].forEach((v) {
        data!.add(FundRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FundRequestData {
  int? id;
  int? branchId;
  String? amount;
  String? reason;
  String? status;
  String? transactionId;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  Branch? branch;

  FundRequestData({
    this.id,
    this.branchId,
    this.amount,
    this.reason,
    this.status,
    this.transactionId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.branch,
  });

  FundRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    amount = json['amount'];
    reason = json['reason'];
    status = json['status'];
    transactionId = json['transaction_id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branch = json['Branch'] != null ? Branch.fromJson(json['Branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['amount'] = amount;
    map['reason'] = reason;
    map['status'] = status;
    map['transaction_id'] = transactionId;
    map['created_by'] = createdBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (branch != null) {
      map['Branch'] = branch!.toJson();
    }
    return map;
  }
}

class Branch {
  int? id;
  String? name;

  Branch({this.id, this.name});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
