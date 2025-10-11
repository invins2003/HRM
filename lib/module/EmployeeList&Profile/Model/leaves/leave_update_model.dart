// lib/module/EmployeeList&Profile/Model/leaves/leave_update_model.dart
class LeaveUpdateModel {
  int? employeeId;
  int? leaveTypeId;
  String? appliedOn;
  String? startDate;
  String? endDate;
  String? totalLeaveDays;
  String? leaveReason;
  String? remark;
  String? status;

  LeaveUpdateModel({
    this.employeeId,
    this.leaveTypeId,
    this.appliedOn,
    this.startDate,
    this.endDate,
    this.totalLeaveDays,
    this.leaveReason,
    this.remark,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (employeeId != null) map['employee_id'] = employeeId;
    if (leaveTypeId != null) map['leave_type_id'] = leaveTypeId;
    if (appliedOn != null) map['applied_on'] = appliedOn;
    if (startDate != null) map['start_date'] = startDate;
    if (endDate != null) map['end_date'] = endDate;
    if (totalLeaveDays != null) map['total_leave_days'] = totalLeaveDays;
    if (leaveReason != null) map['leave_reason'] = leaveReason;
    if (remark != null) map['remark'] = remark;
    if (status != null) map['status'] = status;
    return map;
  }
}
