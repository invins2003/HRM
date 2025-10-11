class Resignation {
  int? id;
  int? employeeId;
  String? noticeDate;
  String? resignationDate;
  String? description;
  int? createdBy;
  String? createdAt;
  String? updatedAt;

  Resignation({
    this.id,
    this.employeeId,
    this.noticeDate,
    this.resignationDate,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Resignation.fromJson(Map<String, dynamic> json) => Resignation(
        id: json['id'],
        employeeId: json['employee_id'],
        noticeDate: json['notice_date'],
        resignationDate: json['resignation_date'],
        description: json['description'],
        createdBy: json['created_by'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "notice_date": noticeDate,
        "resignation_date": resignationDate,
        "description": description,
      };
}

class ResignationResponse {
  bool? success;
  String? message;
  Resignation? data;

  ResignationResponse({this.success, this.message, this.data});

  factory ResignationResponse.fromJson(Map<String, dynamic> json) => ResignationResponse(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? Resignation.fromJson(json['data']) : null,
      );
}
