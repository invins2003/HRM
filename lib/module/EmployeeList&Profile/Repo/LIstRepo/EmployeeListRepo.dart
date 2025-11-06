import 'package:erp_admin/module/EmployeeList&Profile/Model/earlyleaving_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_create_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/leaves/leave_type_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/manual_present_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/overtime_employee_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/resignation/resignation_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/termination/termination_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/termination/termination_type_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeListRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  EmployeeListRepo({required this.apiClient});

  //  final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<Response> employeeListFormRepo() async {
    print("ApiClient.getData ---> ${Constants.EMPLOYEELIST}");
    return await apiClient.getData(Constants.EMPLOYEELIST);
  }

  Future<EarlyLeavingModel> updateEarlyLeaving({
    required String empId,
    required String date,
    required String earlyLeaving,
    required String reason,
  }) async {
    final body = {"date": date, "clock_out": earlyLeaving, "reason": reason};

    final response = await apiClient.patchData(
      "${Constants.EARLYLEAVING}$empId",
      body,
    );

    if (response.statusCode == 200) {
      return EarlyLeavingModel.fromJson(response.body);
    } else if (response.statusCode == 400) {
      return EarlyLeavingModel.fromJson(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<OverTimeModel> updateOverTime({
    required String empId,
    required String date,
    required String overtime,
    required String reason,
  }) async {
    final body = {"date": date, "clock_out": overtime, "reason": reason};

    final response = await apiClient.patchData(
      "${Constants.OVERTIME}$empId",
      body,
    );

    if (response.statusCode == 200) {
      return OverTimeModel.fromJson(response.body);
    } else if (response.statusCode == 400) {
      return OverTimeModel.fromJson(response.body);
    } else {
      throw Exception(response.body["message"]);
    }
  }

  Future<AttendanceStatusResponse> markAttendance({
    required String empId,
    required AttendanceStatusRequest request,
  }) async {
    final response = await apiClient.patchData(
      "${Constants.TOGGLEATTENDENCE}$empId",
      request.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return AttendanceStatusResponse.fromJson(response.body);
    } else {
      throw Exception(response.body["message"] ?? "Unknown error");
    }
  }

  Future<Response> deleteEmployeeRepo(String empId) async {
    debugPrint(
      "ApiClient.deleteData ---> ${Constants.DELETEEMPLOYEEATTENDENCE}/${empId}",
    );
    return await apiClient.deleteData("${Constants.DELETEEMPLOYEE}/${empId}");
  }

  Future<Response> getEmployeeLeaves(String empId) async {
    debugPrint("ApiClient.getData ---> ${Constants.EMPLOYEELEAVE}/${empId}");
    return await apiClient.getData("${Constants.EMPLOYEELEAVE}/${empId}");
  }

  Future<LeaveTypeModel> getLeaveTypes() async {
    final response = await apiClient.getData("${Constants.EMPLOYEELEAVETYPE}");

    if (response.statusCode == 200) {
      return LeaveTypeModel.fromJson(response.body);
    } else {
      throw Exception("${response.body['message']}");
    }
  }

  Future<Response> createLeave(LeaveModel leave) async {
    debugPrint("ApiClient.postData ---> ${Constants.CREATEEMPLOYEELEAVE}");
    return await apiClient.postData(
      Constants.CREATEEMPLOYEELEAVE,
      leave.toJson(),
    );
  }

  Future<Response> deleteLeave(String leaveId) async {
    debugPrint(
      "ApiClient.deleteData ---> ${Constants.CREATEEMPLOYEELEAVE}/$leaveId",
    );
    return await apiClient.deleteData(
      "${Constants.CREATEEMPLOYEELEAVE}/$leaveId",
    );
  }

  Future<Response> updateLeave({
    required String leaveId,
    required Map<String, dynamic> body,
  }) async {
    debugPrint(
      "ApiClient.putData ---> ${Constants.DELETEEMPLOYEELEAVE}/$leaveId",
    );
    return await apiClient.putData(
      "${Constants.DELETEEMPLOYEELEAVE}/$leaveId",
      body,
    );
  }

  Future<List<TerminationType>> getTerminationTypes() async {
    final response = await apiClient.getData(Constants.EMPLOYEETERMINATIONTYPE);

    if (response.statusCode == 200) {
      final jsonData = response.body;
      if (jsonData['success'] == true) {
        return (jsonData['data'] as List)
            .map((e) => TerminationType.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load termination types');
      }
    } else {
      throw Exception(
        'Failed to fetch termination types: ${response.statusCode}',
      );
    }
  }

  Future<TerminationResponse> createTermination({
    required bool isblacklisted,
    required int employeeId,
    required String terminationDate,
    required int terminationType,
    required String description,
  }) async {
    final body = {
      "is_black_List": isblacklisted,
      "employee_id": employeeId,
      "termination_date": terminationDate,
      "termination_type": terminationType,
      "description": description,
    };

    final response = await apiClient.postData(
      Constants.CREATEEMPLOYEETERMINATION,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TerminationResponse.fromJson(response.body);
    } else {
      throw Exception(
        response.body['message'] ?? "Failed to create termination",
      );
    }
  }

  Future<ResignationResponse> createResignation({
    required int employeeId,
    required String resignationDate,
    required String description,
  }) async {
    final body = {
      "employee_id": employeeId,
      "resignation_date": resignationDate,
      "description": description,
    };

    final response = await apiClient.postData(
      Constants.CREATEEMPLOYEERESIGNATION,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResignationResponse.fromJson(response.body);
    } else {
      throw Exception(
        response.body['message'] ?? "Failed to create resignation",
      );
    }
  }

  Future<Response> getEmployeeAttendance({
  required String empId,
  required int month,
  required int year,
}) async {
  debugPrint(
      "ApiClient.getData ---> ${Constants.VIEWATTENDENCEDETAIL}$empId?month=$month&year=$year");

  return await apiClient.getData(
    "${Constants.VIEWATTENDENCEDETAIL}$empId?month=$month&year=$year",
  );
}
}
