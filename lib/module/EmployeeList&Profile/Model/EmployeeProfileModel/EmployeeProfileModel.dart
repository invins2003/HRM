class EmployeeProfileModel {
  bool? success;
  Data? data;

  EmployeeProfileModel({this.success, this.data});

  EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class Data {
  int? id;
  int? userId;
  String? name;
  String? dob;
  String? gender;
  String? phone;
  String? address;
  String? email;
  String? password;
  String? employeeId;
  List<List<double>>? biometricEmpId; // ✅ fixed
  int? branchId;
  int? departmentId;
  int? designationId;
  String? companyDoj;
  String? documents;
  String? accountHolderName;
  String? accountNumber;
  String? bankName;
  String? bankIdentifierCode;
  String? branchLocation;
  String? taxPayerId;
  String? account;
  String? salaryType;
  String? salary;
  bool? isActive;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  User? user;
  Branch? branch;
  Branch? department;
  Branch? designation;

  Data({
    this.id,
    this.userId,
    this.name,
    this.dob,
    this.gender,
    this.phone,
    this.address,
    this.email,
    this.password,
    this.employeeId,
    this.biometricEmpId,
    this.branchId,
    this.departmentId,
    this.designationId,
    this.companyDoj,
    this.documents,
    this.accountHolderName,
    this.accountNumber,
    this.bankName,
    this.bankIdentifierCode,
    this.branchLocation,
    this.taxPayerId,
    this.account,
    this.salaryType,
    this.salary,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.branch,
    this.department,
    this.designation,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    phone = json['phone'];
    address = json['address'];
    email = json['email'];
    password = json['password'];
    employeeId = json['employee_id'];

    // ✅ handle biometric_emp_id as List<List<double>>
    if (json['biometric_emp_id'] != null) {
      biometricEmpId = (json['biometric_emp_id'] as List)
          .map((e) => List<double>.from(e.map((x) => x.toDouble())))
          .toList();
    }

    branchId = json['branch_id'];
    departmentId = json['department_id'];
    designationId = json['designation_id'];
    companyDoj = json['company_doj'];
    documents = json['documents']?.toString();
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    bankIdentifierCode = json['bank_identifier_code'];
    branchLocation = json['branch_location'];
    taxPayerId = json['tax_payer_id'];
    account = json['account']?.toString();
    salaryType = json['salary_type']?.toString();
    salary = json['salary']?.toString();
    isActive = json['is_active'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    department =
        json['department'] != null ? Branch.fromJson(json['department']) : null;
    designation =
        json['designation'] != null ? Branch.fromJson(json['designation']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['user_id'] = userId;
    map['name'] = name;
    map['dob'] = dob;
    map['gender'] = gender;
    map['phone'] = phone;
    map['address'] = address;
    map['email'] = email;
    map['password'] = password;
    map['employee_id'] = employeeId;

    if (biometricEmpId != null) {
      map['biometric_emp_id'] = biometricEmpId;
    }

    map['branch_id'] = branchId;
    map['department_id'] = departmentId;
    map['designation_id'] = designationId;
    map['company_doj'] = companyDoj;
    map['documents'] = documents;
    map['account_holder_name'] = accountHolderName;
    map['account_number'] = accountNumber;
    map['bank_name'] = bankName;
    map['bank_identifier_code'] = bankIdentifierCode;
    map['branch_location'] = branchLocation;
    map['tax_payer_id'] = taxPayerId;
    map['account'] = account;
    map['salary_type'] = salaryType;
    map['salary'] = salary;
    map['is_active'] = isActive;
    map['created_by'] = createdBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) map['user'] = user!.toJson();
    if (branch != null) map['branch'] = branch!.toJson();
    if (department != null) map['department'] = department!.toJson();
    if (designation != null) map['designation'] = designation!.toJson();
    return map;
  }
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}

class Branch {
  int? id;
  String? name;

  Branch({this.id, this.name});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
