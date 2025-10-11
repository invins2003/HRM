

import 'dart:developer';
import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/employee_leaves_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_create_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_type_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/manual_present_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/resignation/resignation_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/termination/termination_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/termination/termination_type_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
RxBool isLeaveLoading = false.obs;
var employeeLeaves = <LeaveData>[].obs;
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
  String? timestamp,
  String? reason // optional, required for Present
}) async {
  try {
    isLoading.value = true;

    final request = AttendanceStatusRequest(
      date: date,
      status: status,
      timestamp: timestamp,
      reason: reason
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


Future<void> fetchEmployeeLeaves(String empId) async {
  try {
    isLeaveLoading.value = true;

    final response = await employeeListRepo.getEmployeeLeaves(empId);

    if (response.statusCode == 200) {
      final leaveModel = EmployeeLeavesModel.fromJson(response.body);
      if (leaveModel.success == true && leaveModel.data != null) {
        employeeLeaves.assignAll(leaveModel.data!);
        log("Employee Leaves fetched: ${employeeLeaves.length} records");
      } else {
        employeeLeaves.clear();
        Get.snackbar("Info", "No leaves found for this employee.");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch employee leaves.");
      log("Failed to fetch leaves: ${response.statusCode} | ${response.statusText}");
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong while fetching leaves.");
    log("Error in fetchEmployeeLeaves: $e");
  } finally {
    isLeaveLoading.value = false;
  }
}

  RxBool isLeaveTypeLoading = false.obs;
  var leaveTypes = <LeaveTypeData>[].obs;


/// Fetch Leave Types
  Future<void> fetchLeaveTypes() async {
    try {
      isLeaveTypeLoading.value = true;
      final response = await employeeListRepo.getLeaveTypes();
      if (response.success == true && response.data != null) {
        leaveTypes.assignAll(response.data!);
        log("Leave Types fetched: ${leaveTypes.length} records");
      } else {
        leaveTypes.clear();
        Get.snackbar("Info", "No leave types found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch leave types.");
      log("Error in fetchLeaveTypes: $e");
    } finally {
      isLeaveTypeLoading.value = false;
    }
  }
  /// Set Default Employee
  void setDefaultEmployee(Data emp) {
    Get.snackbar("Default", "${emp.name} set as default");
  }

Future<bool> createLeave(LeaveModel leave) async {
  try {
    final response = await employeeListRepo.createLeave(leave);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      debugPrint("Error: ${response.body}");
      return false;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return false;
  }
}


Future<void> deleteLeave(String leaveId, String empId) async {
  try {
    isLeaveLoading(true);
    final response = await employeeListRepo.deleteLeave(leaveId);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        "Leave deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Refresh employee leaves list
      await fetchEmployeeLeaves(empId);
    } else {
      Get.snackbar(
        "Error",
        response.body["message"] ?? "Failed to delete leave",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Something went wrong: $e",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLeaveLoading(false);
  }
}

/// Update Leave
Future<void> updateLeaveController(LeaveData leave, {
  required String leaveId,
  required String empId, // To refresh the employee's leave list
  String? leaveReason,
  String? remark,
  String? status,
  int? leaveTypeId,
  String? startDate,
  String? endDate,
  String? totalLeaveDays,
  String? appliedOn,
}) async {
  try {
    isLeaveLoading.value = true;

    // Build request body dynamically based on provided fields
    final body = <String, dynamic>{};
    if (leaveReason != null) body['leave_reason'] = leaveReason;
    if (remark != null) body['remark'] = remark;
    if (status != null) body['status'] = status;
    if (leaveTypeId != null) body['leave_type_id'] = leaveTypeId;
    if (startDate != null) body['start_date'] = startDate;
    if (endDate != null) body['end_date'] = endDate;
    if (totalLeaveDays != null) body['total_leave_days'] = totalLeaveDays;
    if (appliedOn != null) body['applied_on'] = appliedOn;

    final response = await employeeListRepo.updateLeave(leaveId: leaveId, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar(
        "Success",
        "Leave updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Refresh leave list
      await fetchEmployeeLeaves(empId);
    } else {
      Get.snackbar(
        "Error",
        response.body["message"] ?? "Failed to update leave",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Something went wrong: $e",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    log("Error in updateLeaveController: $e");
  } finally {
    isLeaveLoading.value = false;
  }
}





RxBool isTerminationTypeLoading = false.obs;
  var terminationTypes = <TerminationType>[].obs;

  /// Fetch Termination Types
  Future<void> fetchTerminationTypes() async {
    try {
      isTerminationTypeLoading.value = true;
      final types = await employeeListRepo.getTerminationTypes();
      terminationTypes.assignAll(types);
      log("Termination Types fetched: ${terminationTypes.length} records");
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch termination types.");
      log("Error in fetchTerminationTypes: $e");
    } finally {
      isTerminationTypeLoading.value = false;
    }
  }


  RxBool isTerminationLoading = false.obs;
var terminations = <Termination>[].obs;

Future<void> createTerminationController({
  required int employeeId,
  required String terminationDate,
  required int terminationType,
  required String description,
}) async {
  try {
    isTerminationLoading.value = true;

    final response = await employeeListRepo.createTermination(
      employeeId: employeeId,
      terminationDate: terminationDate,
      terminationType: terminationType,
      description: description,
    );

    if (response.success == true) {
      terminations.add(response.data!);
      Get.snackbar("Success", response.message ?? "Termination created");
      log("Termination created: ${response.data}");
    } else {
      Get.snackbar("Failed", response.message ?? "Failed to create termination");
      log("Termination creation failed: ${response.message}");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to create termination.");
    log("Error in createTerminationController: $e");
  } finally {
    isTerminationLoading.value = false;
  }
}


  /// Get termination type name by ID
  String getTerminationTypeName(int? id) {
    if (id == null) return "Unknown";
    final type = terminationTypes.firstWhere(
      (element) => element.id == id,
      orElse: () => TerminationType(id: 0, name: "Unknown"),
    );
    return type.name ?? "Unknown";
  }

/// Get leave type name by ID
String getLeaveTypeName(int? id) {
  if (id == null) return "Unknown Leave";
  final type = leaveTypes.firstWhere(
    (element) => element.id == id,
    orElse: () => LeaveTypeData(id: 0, title: "Unknown Leave", days: 0, createdBy: 0, createdAt: "", updatedAt: "", deletedAt: null),
  );
  return type.title ?? "Unknown Leave";
}




// Resignation
RxBool isResignationLoading = false.obs;
RxBool isResignationTypeLoading = false.obs;
var resignations = <Resignation>[].obs;


Future<void> createResignationController({
  required int employeeId,
  required String resignationDate,
  required String description,
}) async {
  try {
    isResignationLoading.value = true;

    final response = await employeeListRepo.createResignation(
      employeeId: employeeId,
      resignationDate: resignationDate,
      description: description,
    );

    if (response.success == true) {
      resignations.add(response.data!);
      Get.snackbar("Success", response.message ?? "Resignation created");
      log("Resignation created: ${response.data}");
    } else {
      Get.snackbar("Failed", response.message ?? "Failed to create resignation");
      log("Resignation creation failed: ${response.message}");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to create resignation.");
    log("Error in createResignationController: $e");
  } finally {
    isResignationLoading.value = false;
  }
}

}
