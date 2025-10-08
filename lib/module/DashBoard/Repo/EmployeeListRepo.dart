import 'package:erp_admin/module/DashBoard/Model/attendence_request_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  }
Future<Response> presentEmployeeListRepo(DateTime date) async {
  final formattedDate = DateFormat("yyyy-MM-dd").format(date);
    debugPrint("ApiClient.getData ---> ${Constants.PRESENTEMPLOYEE}/date?date=${formattedDate}");
    return await apiClient.getData("${Constants.PRESENTEMPLOYEE}/date?date=${formattedDate}");
  }

  Future<Response> deleteEmployeeAttendenceRepo( String id) async {
    debugPrint("ApiClient.getData ---> ${Constants.DELETEEMPLOYEEATTENDENCE}/${id}");
    return await apiClient.deleteData("${Constants.DELETEEMPLOYEEATTENDENCE}/${id}");
  }


}
