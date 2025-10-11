class Termination {
  int? id;
  String? employeeId;
  String? noticeDate;
  String? terminationDate;
  int? terminationType;
  String? description;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Termination({
    this.id,
    this.employeeId,
    this.noticeDate,
    this.terminationDate,
    this.terminationType,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Termination.fromJson(Map<String, dynamic> json) => Termination(
        id: json['id'],
        employeeId: json['employee_id']?.toString(),
        noticeDate: json['notice_date'],
        terminationDate: json['termination_date'],
        terminationType: json['termination_type'],
        description: json['description'],
        createdBy: json['created_by'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );

  Map<String, dynamic> toJson() => {
        'employee_id': employeeId,
        'notice_date': noticeDate,
        'termination_date': terminationDate,
        'termination_type': terminationType,
        'description': description,
      };
}

class TerminationResponse {
  bool? success;
  String? message;
  Termination? data;

  TerminationResponse({this.success, this.message, this.data});

  factory TerminationResponse.fromJson(Map<String, dynamic> json) => TerminationResponse(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null ? Termination.fromJson(json['data']) : null,
      );
}
