import 'dart:developer';

import 'package:erp_admin/module/auth/Model/loginModel.dart';
import 'package:erp_admin/module/auth/Model/usermodel.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repo/AuthRepo.dart';
import 'BiometricController.dart';

class AuthController extends GetxController {
  final AuthRepo authformRepo;
  AuthController({required this.authformRepo});

  RxBool isLoading = false.obs;

  Future<bool> loginController(String email, String password) async {
    try {
      isLoading.value = true;
      Response response = await authformRepo.authRepo(email, password);
      final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(response.body);

        Fluttertoast.showToast(msg: "Login Successful");
        Get.snackbar("Success", "Login Successful");
        await prefs.setString("USER_TOKEN", loginModel.token ?? "");
        Constants.TOKEN = loginModel.token.toString();
        bool? alreadySet = prefs.getBool("BIOMETRIC_ENABLED");

        if (alreadySet == null) {
          // First time login → ask biometric permission
          final bioCtrl = Get.put(BiometricController());
          bioCtrl.askBiometricPermission();
        } else {
          // If biometric choice already exists → main.dart will handle login flow
          Get.offAllNamed("/main");
        }

        return true;
      } else {
        Fluttertoast.showToast(msg: "Login failed ${response.statusCode}");
        log("Status Code :------ ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
      print("Error --------->>>>>>>>>>>>>>> ${e}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  var isLoading1 = true.obs;
  var hasExpensePermission = false.obs;
  Future<void> fetchCurrentUser() async {
    try {
      isLoading1.value = true;
      final user = await authformRepo.fetchCurrentUser();

      // Check permission logic
      hasExpensePermission.value = user.permissions.any(
        (p) =>
            p == "manage expense" ||
            p == "create expense" ||
            p == "edit expense" ||
            p == "delete expense",
      );
    } catch (e) {
      print("Error fetching user: $e");
    } finally {
      isLoading1.value = false; // Important!
    }
  }
}
