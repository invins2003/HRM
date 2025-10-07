import 'dart:convert';

class AttendanceResponse2 {
  bool? success;
  List<AttendanceData>? data;

  AttendanceResponse2({this.success, this.data});

  factory AttendanceResponse2.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse2(
      success: json['success'],
      data: json['data'] != null
          ? List<AttendanceData>.from(
              json['data'].map((x) => AttendanceData.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((x) => x.toJson()).toList(),
      };
}

class AttendanceData {
  int? id;
  String? date;
  String? status;
  String? clockIn;
  String? clockOut;
  String? late;
  String? earlyLeaving;
  String? overtime;
  int? totalRest;
  String? reason;
  int? createdBy;
  Shift? shift;
  Employee? employee;

  AttendanceData({
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

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
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
        employee: json['employee'] != null
            ? Employee.fromJson(json['employee'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'status': status,
        'clock_in': clockIn,
        'clock_out': clockOut,
        'late': late,
        'early_leaving': earlyLeaving,
        'overtime': overtime,
        'total_rest': totalRest,
        'reason': reason,
        'created_by': createdBy,
        'shift': shift?.toJson(),
        'employee': employee?.toJson(),
      };
}

class Shift {
  int? id;
  String? title;
  String? startTime;
  String? endTime;
  int? breakMinutes;

  Shift({this.id, this.title, this.startTime, this.endTime, this.breakMinutes});

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json['id'],
        title: json['title'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        breakMinutes: json['break_minutes'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'start_time': startTime,
        'end_time': endTime,
        'break_minutes': breakMinutes,
      };
}

class Employee {
  int? id;
  String? name;
  String? employeeId;
  int? branchId;
  int? departmentId;
  String? branchName;
  String? departmentName;
  int? createdBy;

  Employee({
    this.id,
    this.name,
    this.employeeId,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.departmentName,
    this.createdBy,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        name: json['name'],
        employeeId: json['employee_id'],
        branchId: json['branch_id'],
        departmentId: json['department_id'],
        branchName: json['branch_name'],
        departmentName: json['department_name'],
        createdBy: json['created_by'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'employee_id': employeeId,
        'branch_id': branchId,
        'department_id': departmentId,
        'branch_name': branchName,
        'department_name': departmentName,
        'created_by': createdBy,
      };
}
