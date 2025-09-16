// import 'package:erp_admin/module/Logout/Repo/LogoutRepo.dart';
// import 'package:get/get.dart';
//
// import '../module/Logout/Controller/LogoutController.dart';
// import '../module/auth/Controller/AuthCotroller.dart';
// import '../module/auth/Repo/AuthRepo.dart';
// import 'ApiClient.dart';
// import 'Constant.dart';
//
// Future<void> init() async {
//   // Connectivity connectivity = Connectivity();
//   // Get.put(NetworkInfo(connectivity));
//
//   Get.lazyPut(() => ApiClient(appBaseUrl: Constants.BASEURL));
//   //
//   // ///Controller
//
//   Get.lazyPut(() => AuthController(authformRepo: Get.find()));
//   Get.lazyPut(() => LogoutController(logoutRepo: Get.find()));
//
//   // Get.lazyPut(() => HomeController(homeRepo: Get.find()));
//   // Get.lazyPut(() => StartMatchController(startMatchRepository: Get.find()));
//   // //  Get.lazyPut(() => GpUserAuthController(gpUserAuthRepo:Get.find()));
//   // //  Get.lazyPut(() => GpUserHomeController(gpUserHomeRepo:Get.find(),));
//   //
//   // ///Repo
//   //
//   Get.lazyPut(() => AuthRepo(apiClient: Get.find()));
//   Get.lazyPut(() => LogoutRepo(apiClient: Get.find()));
//   // Get.lazyPut(() => HomeRepo(apiClient: Get.find()));
//   // Get.lazyPut(() => StartMatchRepository(apiClient: Get.find()));
//   // //  Get.lazyPut(() => GpUserHomeRepo(apiClient: Get.find()));
// }

import 'package:get/get.dart';

import '../module/DashBoard/Controller/EmployeeListController.dart';
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
  Get.lazyPut(() => EmployeeList(employeeListRepo: Get.find()));
  Get.lazyPut(() => EmployeeListController(employeeListRepo: Get.find()));
  Get.lazyPut(() => EmployeeProfileController(employeeProfileRepo: Get.find()));

  /// Repo
  Get.lazyPut(() => AuthRepo(apiClient: Get.find()));
  Get.lazyPut(() => LogoutRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeListRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeProfileRepo(apiClient: Get.find()));
}
