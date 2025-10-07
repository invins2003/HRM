import 'dart:developer';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/DashBoard/Model/attendence_request_model.dart';
import 'package:erp_admin/module/DashBoard/Repo/EmployeeListRepo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashBoardEmployeeList extends GetxController {
  DashBoardEmployeeListRepo employeeListRepo;
  DashBoardEmployeeList({required this.employeeListRepo});

  RxBool isLoading = false.obs;
  var employeelisttt = <Data>[].obs;
  var errorMs = "".obs;

  /// Map to store employees who already have biometrics registered
  var biometricRegistered = <int, String>{}.obs; // employeeId : name

  /// List of employees without biometrics (to register)
  var biometricPending = <Data>[].obs;

  Future<void> listtController() async {
    try {
      isLoading.value = true;
      Response response = await employeeListRepo.employeeListFormRepo();
      log("Response ------------------------->${response.body.toString()}");

      if (response.statusCode == 200) {
        final listModel = EmployeesListModel.fromJson(response.body);
        if (listModel.success == true && listModel.data != null) {
          employeelisttt.assignAll(listModel.data!);

          // filter biometrics
          biometricRegistered.clear();
          biometricPending.clear();

          for (var emp in listModel.data!) {
              biometricPending.add(emp);
          }

          log("✅ Registered Biometrics: ${biometricRegistered.length}");
          log("🕒 Pending Biometrics: ${biometricPending.length}");
        }
      } else {
        print("ERROR :- ${response.statusCode} | ${response.statusText}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : ${e}');
      log("Error ------>....>>  ${e}");
    } finally {
      isLoading.value = false;
    }
  }
Future<void> verifyAttendance(List<double> embedding, String employeeId) async {
  try {
    // Optional: You can use an RxBool if you want to show loading in UI
    final request = AttendanceRequest(
      embedding: embedding,
      timestamp: DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.now()),
    );

    final response = await employeeListRepo.verifyAttendance(request,employeeId);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Check-in Success",
        "Attendance verified successfully ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Check-in Failed",
        "${response.body["message"]}",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Attendance verification failed: $e",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
  

  /// Check if an employee is already registered for biometrics
  String checkBiometricStatus(int empId) {
    if (biometricRegistered.containsKey(empId)) {
      return "Already Registered";
    } else {
      return "Go for Registration";
    }
  }
}
