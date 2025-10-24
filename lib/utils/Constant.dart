import 'package:erp_admin/config/env_config.dart';

class Constants {

  static String TOKEN = "";
  static String get BASEURL => EnvConfig.baseUrl;


// auth
  static const String LOGIN = "/api/auth/login";
  static const String LOGOUT = "/api/auth/logout";
  static const String ME = "/api/auth/me";  

  


// employees 
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
  static const String VIEWATTENDENCEDETAIL = "/api/attendance/attendance-summary/";

// Employee Leave
static const String EMPLOYEELEAVETYPE = "/api/leave-types";
static const String EMPLOYEELEAVE = "/api/leaves/employee";
static const String CREATEEMPLOYEELEAVE = "/api/leaves";
static const String DELETEEMPLOYEELEAVE = "/api/leaves";


// termination
static const String EMPLOYEETERMINATIONTYPE = "/api/termination-types";
static const String CREATEEMPLOYEETERMINATION = "/api/terminations";


// RESIGNATION
static const String CREATEEMPLOYEERESIGNATION = "/api/resignations";


// expense
static const String CREATEEXPENSE = "/api/expense";
static const String GETEXPENSE = "/api/expense";
static const String GETBALANCE = "/api/branch-wallets";
static const String FUNDREQUEST ="/api/fund-request" ;
static const String MYFUNDREQUEST ="/api/fund-request/my" ;
static const String STATUSUPDATE ="/api/fund-request" ;

// PROFILE
static const String MYPROFILE = "/api/profile";




}
