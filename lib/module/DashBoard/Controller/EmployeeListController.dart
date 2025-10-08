import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/DashBoard/Model/attendence_request_model.dart';
import 'package:erp_admin/module/DashBoard/Model/present_employee_model.dart';
import 'package:erp_admin/module/DashBoard/Repo/EmployeeListRepo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class DashBoardEmployeeList extends GetxController {
  DashBoardEmployeeListRepo employeeListRepo;
  DashBoardEmployeeList({required this.employeeListRepo});

  RxBool isLoading = false.obs;
  var employeelisttt = <Data>[].obs;
  var attendanceList = <AttendanceData>[].obs; // <-- changed type
  var errorMs = "".obs;

  var biometricRegistered = <int, String>{}.obs; // employeeId : name
  var biometricPending = <Data>[].obs;

  Future<void> listtController() async {
    try {
      isLoading.value = true;
      Response response = await employeeListRepo.employeeListFormRepo();

      if (response.statusCode == 200) {
        final listModel = EmployeesListModel.fromJson(response.body);
        if (listModel.success == true && listModel.data != null) {
          employeelisttt.assignAll(listModel.data!);

          biometricRegistered.clear();
          biometricPending.clear();

          for (var emp in listModel.data!) {
            biometricPending.add(emp);
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : ${e}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> presentListtController(DateTime date) async {
    try {
      isLoading.value = true;
      Response response = await employeeListRepo.presentEmployeeListRepo(date);

      if (response.statusCode == 200) {
        final listModel = AttendanceResponse2.fromJson(response.body);

        if (listModel.success == true && listModel.data != null) {
          // Assign AttendanceData list directly
          attendanceList.assignAll(listModel.data!);

          biometricRegistered.clear();
          biometricPending.clear();

          // Convert AttendanceData.employee to Data for biometric tracking
          for (var empAttendance in listModel.data!) {
            if (empAttendance.employee != null) {
              biometricPending.add(Data(
                id: empAttendance.employee!.id,
                name: empAttendance.employee!.name,
                employeeId: empAttendance.employee!.employeeId,
                email: null,
              ));
            }
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyAttendance(List<double> embedding, String employeeId) async {
    try {
      final request = AttendanceRequest(
        embedding: embedding,
        timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      final response = await employeeListRepo.verifyAttendance(request, employeeId);

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

  String checkBiometricStatus(int empId) {
    return biometricRegistered.containsKey(empId)
        ? "Already Registered"
        : "Go for Registration";
  }
}
