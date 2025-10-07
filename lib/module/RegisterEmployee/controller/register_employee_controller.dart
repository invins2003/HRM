import 'package:erp_admin/module/RegisterEmployee/model/employee_biometric_model.dart';
import 'package:erp_admin/module/RegisterEmployee/repository/employee_biometric_repository.dart';
import 'package:get/get.dart';

class RegisterEmployeeController extends GetxController {
  final EmployeeRepository repository = EmployeeRepository();


  var isLoading = false.obs;
  var success = false.obs;
  var errorMsg = ''.obs;

  Future<void> registerBiometric(String employeeId, List<List<double>> embeddings) async {
    isLoading.value = true;
    errorMsg.value = '';
    success.value = false;

    final model = EmployeeBiometricModel(embedding: embeddings);

    final result = await repository.patchBiometricEmbedding(employeeId, model);

    if (result) {
      success.value = true;
    } else {
      errorMsg.value = 'Failed to register biometric';
    }

    isLoading.value = false;
  }
}
