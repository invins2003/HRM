class EarlyLeavingModel {
  final bool success;
  final String message;

  EarlyLeavingModel({
    required this.success,
    required this.message,
  });

  factory EarlyLeavingModel.fromJson(Map<String, dynamic> json) {
    return EarlyLeavingModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}