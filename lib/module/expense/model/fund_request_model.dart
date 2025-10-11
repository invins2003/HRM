class FundRequestModel {
  bool? success;
  FundRequestData? data;

  FundRequestModel({this.success, this.data});

  FundRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? FundRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class FundRequestData {
  int? id;
  int? branchId;
  double? amount;
  String? reason;
  String? status;
  String? transactionId;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

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
  });

  FundRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    amount = (json['amount'] as num?)?.toDouble();
    reason = json['reason'];
    status = json['status'];
    transactionId = json['transaction_id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'amount': amount,
      'reason': reason,
      'status': status,
      'transaction_id': transactionId,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
