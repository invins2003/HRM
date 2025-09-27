import 'package:erp_admin/module/MainScreen/MainScreen.dart';
import 'package:erp_admin/module/Profile/Screens/ProfileScreen.dart';
import 'package:erp_admin/module/auth/screens/signin.dart';
import 'package:get/get.dart';

import '../module/DashBoard/Screens/DashBoardScreen.dart';
import '../module/EmployeeList&Profile/Screens/EmployeeListScreen.dart';

class AppRouts {
  static const String initialRouts = '/loginscreen';

  static const String mainScreen = "/mainscreen";
  static const String dashboardscreen = '/dashboardscreen';
  static const String employeelistscreen = '/employeelistscreen';
  static const String profilescreen = '/profilescreen';

  static List<GetPage> page = [
    GetPage(name: initialRouts, page: () => LoginScreen()),
    GetPage(name: mainScreen, page: () => Mainscreen()),
    GetPage(name: dashboardscreen, page: () => Dashboardscreen()),
    GetPage(name: employeelistscreen, page: () => EmployeeScreen()),
    GetPage(name: profilescreen, page: () => ProfileScreen()),
  ];
}
