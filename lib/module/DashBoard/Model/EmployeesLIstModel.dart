// class EmployeesListModel {
//   bool? success;
//   List<Data>? data;
//
//   EmployeesListModel({this.success, this.data});
//
//   EmployeesListModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   int? userId;
//   String? name;
//   String? dob;
//   String? gender;
//   String? phone;
//   String? address;
//   String? email;
//   String? password;
//   String? employeeId;
//   Null? biometricEmpId;
//   int? branchId;
//   int? departmentId;
//   int? designationId;
//   String? companyDoj;
//   String? documents;
//   String? accountHolderName;
//   String? accountNumber;
//   String? bankName;
//   String? bankIdentifierCode;
//   String? branchLocation;
//   String? taxPayerId;
//   Null? account;
//   Null? salaryType;
//   Null? salary;
//   bool? isActive;
//   int? createdBy;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//   Branch? branch;
//   Branch? department;
//   Branch? designation;
//
//   Data({
//     this.id,
//     this.userId,
//     this.name,
//     this.dob,
//     this.gender,
//     this.phone,
//     this.address,
//     this.email,
//     this.password,
//     this.employeeId,
//     this.biometricEmpId,
//     this.branchId,
//     this.departmentId,
//     this.designationId,
//     this.companyDoj,
//     this.documents,
//     this.accountHolderName,
//     this.accountNumber,
//     this.bankName,
//     this.bankIdentifierCode,
//     this.branchLocation,
//     this.taxPayerId,
//     this.account,
//     this.salaryType,
//     this.salary,
//     this.isActive,
//     this.createdBy,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//     this.branch,
//     this.department,
//     this.designation,
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     name = json['name'];
//     dob = json['dob'];
//     gender = json['gender'];
//     phone = json['phone'];
//     address = json['address'];
//     email = json['email'];
//     password = json['password'];
//     employeeId = json['employee_id'];
//     biometricEmpId = json['biometric_emp_id'];
//     branchId = json['branch_id'];
//     departmentId = json['department_id'];
//     designationId = json['designation_id'];
//     companyDoj = json['company_doj'];
//     documents = json['documents'];
//     accountHolderName = json['account_holder_name'];
//     accountNumber = json['account_number'];
//     bankName = json['bank_name'];
//     bankIdentifierCode = json['bank_identifier_code'];
//     branchLocation = json['branch_location'];
//     taxPayerId = json['tax_payer_id'];
//     account = json['account'];
//     salaryType = json['salary_type'];
//     salary = json['salary'];
//     isActive = json['is_active'];
//     createdBy = json['created_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     branch = json['branch'] != null
//         ? new Branch.fromJson(json['branch'])
//         : null;
//     department = json['department'] != null
//         ? new Branch.fromJson(json['department'])
//         : null;
//     designation = json['designation'] != null
//         ? new Branch.fromJson(json['designation'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['name'] = this.name;
//     data['dob'] = this.dob;
//     data['gender'] = this.gender;
//     data['phone'] = this.phone;
//     data['address'] = this.address;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['employee_id'] = this.employeeId;
//     data['biometric_emp_id'] = this.biometricEmpId;
//     data['branch_id'] = this.branchId;
//     data['department_id'] = this.departmentId;
//     data['designation_id'] = this.designationId;
//     data['company_doj'] = this.companyDoj;
//     data['documents'] = this.documents;
//     data['account_holder_name'] = this.accountHolderName;
//     data['account_number'] = this.accountNumber;
//     data['bank_name'] = this.bankName;
//     data['bank_identifier_code'] = this.bankIdentifierCode;
//     data['branch_location'] = this.branchLocation;
//     data['tax_payer_id'] = this.taxPayerId;
//     data['account'] = this.account;
//     data['salary_type'] = this.salaryType;
//     data['salary'] = this.salary;
//     data['is_active'] = this.isActive;
//     data['created_by'] = this.createdBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     if (this.branch != null) {
//       data['branch'] = this.branch!.toJson();
//     }
//     if (this.department != null) {
//       data['department'] = this.department!.toJson();
//     }
//     if (this.designation != null) {
//       data['designation'] = this.designation!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   String? name;
//   String? email;
//
//   User({this.id, this.name, this.email});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     return data;
//   }
// }
//
// class Branch {
//   int? id;
//   String? name;
//
//   Branch({this.id, this.name});
//
//   Branch.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     return data;
//   }
// }

class EmployeesListModel {
  bool? success;
  List<Data>? data;

  EmployeesListModel({this.success, this.data});

  EmployeesListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
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
  Null biometricEmpId;
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
  Null account;
  Null salaryType;
  Null salary;
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
    biometricEmpId = json['biometric_emp_id'];
    branchId = json['branch_id'];
    departmentId = json['department_id'];
    designationId = json['designation_id'];
    companyDoj = json['company_doj'];
    documents = json['documents'];
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    bankIdentifierCode = json['bank_identifier_code'];
    branchLocation = json['branch_location'];
    taxPayerId = json['tax_payer_id'];
    account = json['account'];
    salaryType = json['salary_type'];
    salary = json['salary'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    branch = json['branch'] != null
        ? new Branch.fromJson(json['branch'])
        : null;
    department = json['department'] != null
        ? new Branch.fromJson(json['department'])
        : null;
    designation = json['designation'] != null
        ? new Branch.fromJson(json['designation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['password'] = this.password;
    data['employee_id'] = this.employeeId;
    data['biometric_emp_id'] = this.biometricEmpId;
    data['branch_id'] = this.branchId;
    data['department_id'] = this.departmentId;
    data['designation_id'] = this.designationId;
    data['company_doj'] = this.companyDoj;
    data['documents'] = this.documents;
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['bank_name'] = this.bankName;
    data['bank_identifier_code'] = this.bankIdentifierCode;
    data['branch_location'] = this.branchLocation;
    data['tax_payer_id'] = this.taxPayerId;
    data['account'] = this.account;
    data['salary_type'] = this.salaryType;
    data['salary'] = this.salary;
    data['is_active'] = this.isActive;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.designation != null) {
      data['designation'] = this.designation!.toJson();
    }
    return data;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
