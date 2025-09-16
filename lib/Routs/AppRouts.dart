import 'package:erp_admin/module/MainScreen/MainScreen.dart';
import 'package:erp_admin/module/Profile/Screens/ProfileScreen.dart';
import 'package:erp_admin/module/auth/screens/forgotPassword.dart';
import 'package:erp_admin/module/auth/screens/signin.dart';
import 'package:erp_admin/module/auth/screens/signup.dart';
import 'package:get/get.dart';

import '../module/DashBoard/Screens/DashBoardScreen.dart';
import '../module/EmployeeList&Profile/Screens/EmployeeListScreen.dart';

class AppRouts {
  static const String initialRouts = '/loginscreen';

  static const String mainScreen = "/mainscreen";
  // static const String signupScreen = '/signupscreen';
  // static const String forgotpassword = '/forgotpassword';
  static const String dashboardscreen = '/dashboardscreen';
  static const String employeelistscreen = '/employeelistscreen';
  static const String profilescreen = '/profilescreen';

  static List<GetPage> page = [
    GetPage(name: initialRouts, page: () => Loginscreen()),
    GetPage(name: mainScreen, page: () => Mainscreen()),
    // GetPage(name: signupScreen, page: () => SignUpScreen()),
    // GetPage(name: forgotpassword, page: () => ForgotPassword()),
    GetPage(name: dashboardscreen, page: () => Dashboardscreen()),
    GetPage(name: employeelistscreen, page: () => EmployeeScreen()),
    GetPage(name: profilescreen, page: () => ProfileScreen()),
  ];
}
