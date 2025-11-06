// lib/module/DashBoard/Model/attendance_status_model.dart
class AttendanceStatusRequest {
  String date;
  String status;
  String? clockOut;
  String? timestamp; 
  String? reason;// optional for Absent

  AttendanceStatusRequest({
    required this.date,
    required this.status,
    this.timestamp,
    this.reason,
    this.clockOut
  });

  Map<String, dynamic> toJson() {
    final map = {
      "date": date,
      "status": status,
    };
    if (timestamp != null && timestamp!.isNotEmpty) {
      map["clock_in"] = timestamp!;
    }
    if (clockOut != null && clockOut!.isNotEmpty) {
      map["clock_out"] = clockOut!;
    }
    if (reason != null && reason!.isNotEmpty) {
      map["reason"] = reason!;
    }
    return map;
  }

  factory AttendanceStatusRequest.fromJson(Map<String, dynamic> json) {
    return AttendanceStatusRequest(
      date: json['date'] ?? "",
      status: json['status'] ?? "",
      timestamp: json['clock_in'],
      reason: json['reason'],
      clockOut: json['clock_out']
    );
  }
}

class AttendanceStatusResponse {
  bool success; // changed to bool
  String message;

  AttendanceStatusResponse({
    required this.success,
    required this.message,
  });

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceStatusResponse(
      success: json['success'] ?? false, // default false if missing
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}
