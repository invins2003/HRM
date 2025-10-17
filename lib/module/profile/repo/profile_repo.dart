import 'package:erp_admin/module/profile/model/profile_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';

class ProfileRepo {
  final ApiClient apiClient = ApiClient(appBaseUrl: Constants.BASEURL);

  Future<ProfileModel> getProfile() async {
    final response = await apiClient.getData(Constants.MYPROFILE);
    print("Profile API Response: ${response.bodyString}"); // Debug

    if (response.statusCode == 200) {
      if (response.body is Map<String, dynamic>) {
        return ProfileModel.fromJson(response.body);
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      String errorMsg = "Failed to fetch profile";
      if (response.body is Map<String, dynamic> && response.body['message'] != null) {
        errorMsg = response.body['message'];
      }
      throw Exception(errorMsg);
    }
  }


   Future<String> getUserNameById(int userId) async {
    final response = await apiClient.getData("/api/users/$userId");
    print("User API Response: ${response.bodyString}"); // Debug

    if (response.statusCode == 200) {
      final data = response.body;
      if (data != null && data['name'] != null) {
        return data['name'];
      } else {
        return "Unknown";
      }
    } else {
      return "Unknown";
    }
  }
}
