import 'package:erp_admin/module/auth/Model/usermodel.dart';
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


  Future<UserModel> fetchCurrentUser() async {
    print("ApiClient.GetData -------> ${Constants.ME}");
    final response = await apiClient.getData(Constants.ME);

    if (response.statusCode == 200) {
      print("User fetched successfully: ${response.body}");
      return UserModel.fromJson(response.body);
    } else {
      print("Failed to fetch user: ${response.statusText}");
      throw Exception("Failed to fetch user data");
    }
  }
}

Map<String, dynamic> toJson(email, password) {
  Map<String, String> data = <String, String>{};
  data['email'] = email;
  data['password'] = password;
  return data;
}
