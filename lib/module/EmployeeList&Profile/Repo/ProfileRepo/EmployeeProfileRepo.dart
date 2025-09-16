import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class EmployeeProfileRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  EmployeeProfileRepo({required this.apiClient});

  Future<Response> profileRepo(int id) async {
    print("apiClient.getData ---- > ${Constants.EMPLOYEEPROFILE} ${id}");
    return apiClient.getData("${Constants.EMPLOYEEPROFILE}$id");
  }
}
