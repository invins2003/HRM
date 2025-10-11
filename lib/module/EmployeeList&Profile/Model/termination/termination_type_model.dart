class TerminationType {
  int? id;
  String? name;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  TerminationType({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TerminationType.fromJson(Map<String, dynamic> json) => TerminationType(
        id: json['id'],
        name: json['name'],
        createdBy: json['created_by'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
        deletedAt: json['deleted_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_by': createdBy,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt,
      };
}

class TerminationTypeResponse {
  bool? success;
  List<TerminationType>? data;

  TerminationTypeResponse({this.success, this.data});

  factory TerminationTypeResponse.fromJson(Map<String, dynamic> json) => TerminationTypeResponse(
        success: json['success'],
        data: json['data'] != null
            ? List<TerminationType>.from(json['data'].map((x) => TerminationType.fromJson(x)))
            : [],
      );
}
