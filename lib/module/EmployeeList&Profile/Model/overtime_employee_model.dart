class OverTimeModel {
  final bool success;
  final String message;

  OverTimeModel({
    required this.success,
    required this.message,
  });

  factory OverTimeModel.fromJson(Map<String, dynamic> json) {
    return OverTimeModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}