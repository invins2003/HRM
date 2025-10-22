class AttendanceRecord {
  final int? id;
  final String? date;
  final String? status;
  final String? clockIn;
  final String? clockOut;
  final String? late;
  final String? earlyLeaving;
  final String? overtime;
  final int? totalRest;
  final String? reason;
  final int? createdBy;
  final Shift? shift;
  final Employee? employee;

  AttendanceRecord({
    this.id,
    this.date,
    this.status,
    this.clockIn,
    this.clockOut,
    this.late,
    this.earlyLeaving,
    this.overtime,
    this.totalRest,
    this.reason,
    this.createdBy,
    this.shift,
    this.employee,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      date: json['date'],
      status: json['status'],
      clockIn: json['clock_in'],
      clockOut: json['clock_out'],
      late: json['late'],
      earlyLeaving: json['early_leaving'],
      overtime: json['overtime'],
      totalRest: json['total_rest'],
      reason: json['reason'],
      createdBy: json['created_by'],
      shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }
}

class Shift {
  final int? id;
  final String? title;
  final String? startTime;
  final String? endTime;
  final int? breakMinutes;

  Shift({this.id, this.title, this.startTime, this.endTime, this.breakMinutes});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      title: json['title'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      breakMinutes: json['break_minutes'],
    );
  }
}

class Employee {
  final int? id;
  final String? name;
  final String? employeeId;
  final int? branchId;
  final int? departmentId;
  final String? branchName;
  final String? departmentName;
  final String? employeeType;
  final int? createdBy;

  Employee({
    this.id,
    this.name,
    this.employeeId,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.departmentName,
    this.employeeType,
    this.createdBy,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      employeeId: json['employee_id'],
      branchId: json['branch_id'],
      departmentId: json['department_id'],
      branchName: json['branch_name'],
      departmentName: json['department_name'],
      employeeType: json['employee_type'],
      createdBy: json['created_by'],
    );
  }
}
