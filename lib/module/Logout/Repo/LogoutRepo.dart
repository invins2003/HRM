import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class LogoutRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  LogoutRepo({required this.apiClient});

  Future<Response> Logout() async {
    print(
      "Apiclient PostDataLogout --- > ${apiClient.postDataLogout(Constants.LOGOUT)}",
    );
    return await apiClient.postDataLogout(Constants.LOGOUT);
  }
}
