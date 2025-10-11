// lib/module/DashBoard/Model/attendance_status_model.dart
class AttendanceStatusRequest {
  String date;
  String status;
  String? timestamp; 
  String? reason;// optional for Absent

  AttendanceStatusRequest({
    required this.date,
    required this.status,
    this.timestamp,
    this.reason
  });

  Map<String, dynamic> toJson() {
    final map = {
      "date": date,
      "status": status,
    };
    if (timestamp != null && timestamp!.isNotEmpty) {
      map["timestamp"] = timestamp!;
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
      timestamp: json['timestamp'],
      reason: json['reason'],
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
