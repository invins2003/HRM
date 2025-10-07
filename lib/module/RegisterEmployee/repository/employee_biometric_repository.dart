
import 'package:erp_admin/module/RegisterEmployee/model/employee_biometric_model.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:get/get.dart';

class EmployeeRepository extends GetxController implements GetxService {
  final ApiClient apiClient = ApiClient(appBaseUrl: Constants.BASEURL);

  EmployeeRepository();

  /// PATCH biometric embeddings for an employee
  Future<bool> patchBiometricEmbedding(
      String employeeId, EmployeeBiometricModel data) async {
    final uri = Constants.BIOMETRICREGISTRATION + employeeId.toString();

    try {
      final response = await apiClient.patchData(uri, data.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to patch embedding: ${response.bodyString}');
        return false;
      }
    } catch (e) {
      print('Error patching embedding: $e');
      return false;
    }
  }
}
