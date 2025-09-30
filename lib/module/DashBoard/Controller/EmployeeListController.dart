import 'dart:developer';

import 'package:erp_admin/module/DashBoard/Model/EmployeesLIstModel.dart';
import 'package:erp_admin/module/DashBoard/Repo/EmployeeListRepo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DashBoardEmployeeList extends GetxController {
  DashBoardEmployeeListRepo employeeListRepo;
  DashBoardEmployeeList({required this.employeeListRepo});

  RxBool isLoading = false.obs;
  var employeelisttt = <Data>[].obs;
  var errorMs = "".obs;

  Future<void> listtController() async {
    try {
      isLoading.value = true;
      Response response = await employeeListRepo.employeeListFormRepo();
      print(response);
      log("Response ------------------------->${response.body.toString()}");
      if (response.statusCode == 200) {
        final listModel = EmployeesListModel.fromJson(response.body);
        if (listModel.success == true && listModel.data != null) {
          employeelisttt.assignAll(listModel.data!);
        }
      } else {
        isLoading.value = false;
        print("ERROR :- ${response.statusCode} | ${response.statusText}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : ${e}');
      log("Error ------>....>>  ${e}");
    } finally {
      isLoading.value = false;
    }
  }
}
