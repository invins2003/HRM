class SuccessLogoutModel {
  final bool success;
  final String message;
  SuccessLogoutModel({required this.success, required this.message});

  factory SuccessLogoutModel.formJson(Map<String, dynamic> json) {
    return SuccessLogoutModel(
      success: json['success'].toString() == "true" || json['succes'] == true,
      message: json['message'] ?? "",
    );
  }
}
