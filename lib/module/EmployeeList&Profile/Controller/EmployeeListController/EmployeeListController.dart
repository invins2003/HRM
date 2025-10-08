

import 'dart:developer';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/manual_present_model.dart';
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

  Future<void> updateEarlyLeavingController({
  required String empId,
  required String date,
  required String earlyLeaving,
  required String reason,
}) async {
  try {
    isLoading.value = true;

    final response = await employeeListRepo.updateEarlyLeaving(
      empId: empId,
      date: date,
      earlyLeaving: earlyLeaving,
      reason: reason,
    );

    if (response.success == true) {
      Get.snackbar("Success", response.message);
      log("Early Leaving Updated: ${response}");
    } else {
      Get.snackbar("Failed", response.message);
      log("Update failed: ${response}");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to update early leaving please try after sometime.");
    log("Error in updateEarlyLeavingController ---> $e");
  } finally {
    isLoading.value = false;
  }
}


 Future<void> updateOverTimeController({
  required String empId,
  required String date,
  required String overtime,
  required String reason,
}) async {
  try {
    isLoading.value = true;

    final response = await employeeListRepo.updateOverTime(
      empId: empId,
      date: date,
      overtime: overtime,
      reason: reason,
    );

    if (response.success == true) {
      Get.snackbar("Success", response.message);
      log("Over-Time Updated: ${response}");
    } else {
      Get.snackbar("Failed", response.message);
      log("Update failed: ${response}");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to update early leaving!! please try after sometime.");
    log("Error in updateOverTimeController ---> $e");
  } finally {
    isLoading.value = false;
  }
}


Future<void> markAttendanceController({
  required String empId,
  required String date,
  required String status, // "Present" or "Absent"
  String? timestamp, // optional, required for Present
}) async {
  try {
    isLoading.value = true;

    final request = AttendanceStatusRequest(
      date: date,
      status: status,
      timestamp: timestamp,
    );

    final response = await employeeListRepo.markAttendance(
      empId: empId,
      request: request,
    );

    if (response.success == true) {
      Get.snackbar("Success", response.message);
      log("Attendance Updated: $response");
    } else {
      Get.snackbar("Failed", response.message);
      log("Attendance update failed: $response");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to mark attendance.");
    log("Error in markAttendanceController: $e");
  } finally {
    isLoading.value = false;
  }
}
  /// Delete Employee
Future<void> deleteEmployee(Data emp) async {
  try {
    isLoading.value = true;

    final response = await employeeListRepo.deleteEmployeeRepo(emp.employeeId!);

    if (response.statusCode == 200) {
      employeelisttt.remove(emp); // remove from list
      filteredList.remove(emp); // also remove from filtered list
      Get.snackbar("Deleted", "${emp.name} removed successfully");
      log("Deleted Employee ID: ${emp.employeeId}");
    } else {
      Get.snackbar("Failed", response.body["message"] ?? "Delete failed");
      log("Delete failed: ${response.body}");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to delete employee.");
    log("Error in deleteEmployee: $e");
  } finally {
    isLoading.value = false;
  }
}


  /// Set Default Employee
  void setDefaultEmployee(Data emp) {
    Get.snackbar("Default", "${emp.name} set as default");
    // TODO: call API if backend supports default employee
  }

}
