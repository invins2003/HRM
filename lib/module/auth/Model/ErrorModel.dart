class ErrorModel {
  int? statusCode;
  String? message;
  Map<String, dynamic>? errors; // optional: for multiple field errors

  ErrorModel({this.statusCode, this.message, this.errors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? json['status'];
    message = json['message'] ?? json['error'] ?? "Something went wrong";
    errors =
        json['errors']; // e.g., {"email": "Invalid email", "password": "Too short"}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors;
    }
    return data;
  }
}
