// import 'dart:developer';
//
// import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
//
// import '../../Repo/LIstRepo/EmployeeListRepo.dart';
//
// class EmployeeListController extends GetxController {
//   EmployeeListRepo employeeListRepo;
//   EmployeeListController({required this.employeeListRepo});
//
//   RxBool isLoading = false.obs;
//   var employeelisttt = <Data>[].obs;
//   var errorMs = "".obs;
//
//   Future<void> listtController() async {
//     try {
//       isLoading.value = true;
//       Response response = await employeeListRepo.employeeListFormRepo();
//       print(response);
//       log("Response ------------------------->${response.body.toString()}");
//       if (response.statusCode == 200) {
//         final listModel = EmployeesListModel.fromJson(response.body);
//         if (listModel.success == true && listModel.data != null) {
//           employeelisttt.assignAll(listModel.data!);
//         }
//       } else {
//         isLoading.value = false;
//         print("ERROR :- ${response.statusCode} | ${response.statusText}");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error : ${e}');
//       log("Error ------>....>>  ${e}");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:developer';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../Repo/LIstRepo/EmployeeListRepo.dart';

class EmployeeListController extends GetxController {
  EmployeeListRepo employeeListRepo;
  EmployeeListController({required this.employeeListRepo});

  RxBool isLoading = false.obs;
  var employeelisttt = <Data>[].obs; // full list from API
  var filteredList = <Data>[].obs; // list after search
  // var errorMs = "".obs;

  /// Fetch Employee List
  Future<void> listtController() async {
    try {
      isLoading.value = true;
      Response response = await employeeListRepo.employeeListFormRepo();
      log("Response ------------------------->${response.body.toString()}");

      if (response.statusCode == 200) {
        final listModel = EmployeesListModel.fromJson(response.body);
        if (listModel.success == true && listModel.data != null) {
          employeelisttt.assignAll(listModel.data!);
          filteredList.assignAll(listModel.data!); // initialize filtered list
        }
      } else {
        isLoading.value = false;
        log("ERROR :- ${response.statusCode} | ${response.statusText}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : $e');
      log("Error ------>....>>  $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Search Function
  void filterEmployees(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(employeelisttt); // reset to full list
    } else {
      filteredList.assignAll(
        employeelisttt.where(
          (emp) =>
              (emp.name?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (emp.email?.toLowerCase().contains(query.toLowerCase()) ?? false),
        ),
      );
    }
  }

  /// Delete Employee
  void deleteEmployee(Data emp) {
    employeelisttt.remove(emp); // remove from list
    Get.snackbar("Deleted", "${emp.name} removed successfully");
    // TODO: call Delete API here if backend exists
  }

  /// Set Default Employee
  void setDefaultEmployee(Data emp) {
    Get.snackbar("Default", "${emp.name} set as default");
    // TODO: call API if backend supports default employee
  }
}
