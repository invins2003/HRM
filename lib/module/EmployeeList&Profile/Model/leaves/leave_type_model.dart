class LeaveTypeModel {
  bool? success;
  List<LeaveTypeData>? data;

  LeaveTypeModel({this.success, this.data});

  LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <LeaveTypeData>[];
      json['data'].forEach((v) {
        data!.add(LeaveTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LeaveTypeData {
  int? id;
  String? title;
  int? days;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  LeaveTypeData({
    this.id,
    this.title,
    this.days,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  LeaveTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    days = json['days'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'days': days,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
