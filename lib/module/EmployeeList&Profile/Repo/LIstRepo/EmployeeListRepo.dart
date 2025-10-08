import 'package:erp_admin/module/EmployeeList&Profile/Model/earlyleaving_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/manual_present_model.dart';
import 'package:erp_admin/module/EmployeeList&Profile/Model/overtime_employee_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class EmployeeListRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  EmployeeListRepo({required this.apiClient});

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
  final body = {
    "date": date,
    "clock_out": earlyLeaving,
    "reason": reason,
  };

  final response = await apiClient.patchData(
    "${Constants.EARLYLEAVING}$empId",
    body,
  );

  if (response.statusCode == 200) {
    return EarlyLeavingModel.fromJson(response.body);
  } 
  else if(response.statusCode == 400) {
      return EarlyLeavingModel.fromJson(response.body);
  }
  else {
    throw Exception(response.body);
  }
}

Future<OverTimeModel> updateOverTime({
  required String empId,
  required String date,
  required String overtime,
  required String reason,
}) async {
  final body = {
    "date": date,
    "overtime": overtime,
    "reason": reason,
  };

  final response = await apiClient.patchData(
    "${Constants.OVERTIME}$empId",
    body,
  );

  if (response.statusCode == 200) {
    return OverTimeModel.fromJson(response.body);

  } 
  else if(response.statusCode == 400) {
      return OverTimeModel.fromJson(response.body);
  }
  else {
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
}
