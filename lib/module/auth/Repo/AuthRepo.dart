import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class AuthRepo extends GetxController implements GetxService {
  ApiClient apiClient;
  AuthRepo({required this.apiClient});

  Future<Response> authRepo(String email, String password) async {
    print(
      "ApiClient.PostData -------> ${Constants.LOGIN} ${toJson(email, password)}",
    );
    return await apiClient.post(Constants.LOGIN, toJson(email, password));
  }
}

Map<String, dynamic> toJson(email, password) {
  Map<String, String> data = <String, String>{};
  data['email'] = email;
  data['password'] = password;
  return data;
}
