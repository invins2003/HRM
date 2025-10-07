// lib/module/attendance/models/attendance_model.dart
class AttendanceRequest {
  final List<double> embedding;
  final String timestamp;

  AttendanceRequest({required this.embedding, required this.timestamp});

  Map<String, dynamic> toJson() => {
        "embedding": embedding,
        "timestamp": timestamp,
      };
}

class AttendanceResponse {
  final bool success;
  final String message;

  AttendanceResponse({required this.success, required this.message});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
