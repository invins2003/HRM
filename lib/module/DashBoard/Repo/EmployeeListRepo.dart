import 'package:erp_admin/module/DashBoard/Model/attendence_request_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoardEmployeeListRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  DashBoardEmployeeListRepo({required this.apiClient});

  Future<Response> employeeListFormRepo() async {
    debugPrint("ApiClient.getData ---> ${Constants.EMPLOYEELIST}");
    return await apiClient.getData(Constants.EMPLOYEELIST);
  }

  Future<Response> verifyAttendance(AttendanceRequest request,String empId) async {

    debugPrint("ApiClient.getData ---> ${Constants.EMPLOYEEATTENDENCE}");
    return await apiClient.postData("${Constants.EMPLOYEEATTENDENCE}$empId", request.toJson());
  //   final url = Uri.parse('$baseUrl/api/attendance/attendance/verify');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(request.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     return AttendanceResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception("Server error: ${response.statusCode}");
  //   }
  }
}
