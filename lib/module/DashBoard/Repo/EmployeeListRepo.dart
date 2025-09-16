import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class EmployeeRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  EmployeeRepo({required this.apiClient});

  Future<Response> employeeListFormRepo() async {
    print("ApiClient.getData ---> ${Constants.EMPLOYEELIST}");
    return await apiClient.getData(Constants.EMPLOYEELIST);
  }
}
