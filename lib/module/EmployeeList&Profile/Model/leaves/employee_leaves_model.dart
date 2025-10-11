class EmployeeLeavesModel {
  bool? success;
  int? total;
  List<LeaveData>? data;

  EmployeeLeavesModel({this.success, this.total, this.data});

  EmployeeLeavesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
    if (json['data'] != null) {
      data = <LeaveData>[];
      json['data'].forEach((v) {
        data!.add(LeaveData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['total'] = total;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LeaveData {
  int? id;
  String? employeeId;
  int? leaveTypeId;
  String? appliedOn;
  String? startDate;
  String? endDate;
  String? totalLeaveDays;
  String? leaveReason;
  String? remark;
  String? status;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  Employee? employee;
  LeaveType? leaveType;

  LeaveData({
    this.id,
    this.employeeId,
    this.leaveTypeId,
    this.appliedOn,
    this.startDate,
    this.endDate,
    this.totalLeaveDays,
    this.leaveReason,
    this.remark,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.employee,
    this.leaveType,
  });

  LeaveData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    leaveTypeId = json['leave_type_id'];
    appliedOn = json['applied_on'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalLeaveDays = json['total_leave_days'];
    leaveReason = json['leave_reason'];
    remark = json['remark'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
    leaveType = json['leave_type'] != null
        ? LeaveType.fromJson(json['leave_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employee_id'] = employeeId;
    map['leave_type_id'] = leaveTypeId;
    map['applied_on'] = appliedOn;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['total_leave_days'] = totalLeaveDays;
    map['leave_reason'] = leaveReason;
    map['remark'] = remark;
    map['status'] = status;
    map['created_by'] = createdBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (employee != null) map['employee'] = employee!.toJson();
    if (leaveType != null) map['leave_type'] = leaveType!.toJson();
    return map;
  }
}

class Employee {
  int? id;
  String? employeeId;
  String? name;
  int? branchId;

  Employee({this.id, this.employeeId, this.name, this.branchId});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'name': name,
      'branch_id': branchId,
    };
  }
}

class LeaveType {
  int? id;
  String? title;

  LeaveType({this.id, this.title});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
