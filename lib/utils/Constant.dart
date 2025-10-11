class Constants {
  static String TOKEN = ""; // will be set after login
  static const String BASEURL = "https://erpcopy.vnvision.in/";
  static const String LOGIN = "/api/auth/login";
  static const String LOGOUT = "/api/auth/logout";
  static const String EMPLOYEELIST = "/api/employees";
  static const String EMPLOYEEPROFILE = "/api/employees/";
  static const String BIOMETRICREGISTRATION = "/api/employees/biometric/";



// Employee Attendence
  static const String EMPLOYEEATTENDENCE = "/api/attendance/attendance/verify/";
  static const String EARLYLEAVING = "/api/attendance/early-leaving/";
  static const String OVERTIME = "/api/attendance/overtime/";
  static const String PRESENTEMPLOYEE = "/api/attendance";
  static const String TOGGLEATTENDENCE = "/api/attendance/status/";
  static const String DELETEEMPLOYEEATTENDENCE = "/api/attendance";
  static const String DELETEEMPLOYEE = "/api/employees";


// Employee Leave
static const String EMPLOYEELEAVETYPE = "/api/leave-types";
static const String EMPLOYEELEAVE = "/api/leaves/employee";
static const String CREATEEMPLOYEELEAVE = "/api/leaves";


}
