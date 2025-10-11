class LeaveModel {
  int? employeeId;
  int? leaveTypeId;
  String? appliedOn;
  String? startDate;
  String? endDate;
  String? totalLeaveDays;
  String? leaveReason;
  String? remark;

  LeaveModel({
    this.employeeId,
    this.leaveTypeId,
    this.appliedOn,
    this.startDate,
    this.endDate,
    this.totalLeaveDays,
    this.leaveReason,
    this.remark,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      employeeId: json['employee_id'],
      leaveTypeId: json['leave_type_id'],
      appliedOn: json['applied_on'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalLeaveDays: json['total_leave_days']?.toString(),
      leaveReason: json['leave_reason'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "leave_type_id": leaveTypeId,
      "applied_on": appliedOn,
      "start_date": startDate,
      "end_date": endDate,
      "total_leave_days": totalLeaveDays,
      "leave_reason": leaveReason,
      "remark": remark,
    };
  }
}
