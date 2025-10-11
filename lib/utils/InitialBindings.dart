

import 'package:erp_admin/module/DashBoard/Screens/DashBoardScreen.dart';
import 'package:erp_admin/module/expense/controller/expense_controller.dart';
import 'package:erp_admin/module/profile/controller/profile_controller.dart';
import 'package:erp_admin/module/profile/repo/profile_repo.dart';
import 'package:get/get.dart';

import '../module/DashBoard/Controller/EmployeeListController.dart';
import '../module/DashBoard/Controller/EmployeeListController.dart'
    as Dashboardscreen;
import '../module/DashBoard/Repo/EmployeeListRepo.dart';
import '../module/EmployeeList&Profile/Controller/EmployeeListController/EmployeeListController.dart';
import '../module/EmployeeList&Profile/Controller/EmployeeProfileController/EmployeeProfileController.dart';
import '../module/EmployeeList&Profile/Repo/LIstRepo/EmployeeListRepo.dart';
import '../module/EmployeeList&Profile/Repo/ProfileRepo/EmployeeProfileRepo.dart';
import '../module/Logout/Controller/LogoutController.dart';
import '../module/Logout/Repo/LogoutRepo.dart';
import '../module/auth/Controller/AuthCotroller.dart';
import '../module/auth/Repo/AuthRepo.dart';
import 'ApiClient.dart';
import 'Constant.dart';

Future<void> init() async {
  Get.lazyPut(() => ApiClient(appBaseUrl: Constants.BASEURL));

  // / Controller
  Get.lazyPut(() => AuthController(authformRepo: Get.find()));
  Get.lazyPut(() => LogoutController(logoutRepo: Get.find()));
  Get.lazyPut(() => DashBoardEmployeeList(employeeListRepo: Get.find()));
  Get.lazyPut(() => EmployeeListController(employeeListRepo: Get.find()));
  Get.lazyPut(() => EmployeeProfileController(employeeProfileRepo: Get.find()));
  Get.lazyPut(()=>  ProfileController());

  /// Repo
  Get.lazyPut(() => AuthRepo(apiClient: Get.find()));
  Get.lazyPut(() => LogoutRepo(apiClient: Get.find()));
  Get.lazyPut(() => DashBoardEmployeeListRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeListRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeProfileRepo(apiClient: Get.find()));
  Get.lazyPut(()=>ProfileRepo());
}
