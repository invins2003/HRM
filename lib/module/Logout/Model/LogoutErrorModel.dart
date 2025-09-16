class ErrorModel {
  final bool success;
  final String errorCode;
  final String message;

  ErrorModel({
    required this.message,
    required this.errorCode,
    required this.success,
  });

  factory ErrorModel.formJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['succes'] ?? false,
      errorCode: json["error_code"] ?? '',
      success: json['success'] ?? '',
    );
  }
}
