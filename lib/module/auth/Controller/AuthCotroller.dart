import 'dart:developer';
import 'package:erp_admin/module/DashBoard/Screens/DashBoardScreen.dart';
import 'package:erp_admin/module/auth/Model/loginModel.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Repo/AuthRepo.dart';

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

        // ✅ Save Token
        await prefs.setString("USER_TOKEN", loginModel.token ?? "");
        Constants.TOKEN = loginModel.token.toString();

        // ✅ Success Snackbar
        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Navigate directly to Dashboard
        Get.offAll(() => const Dashboardscreen());

        return true;
      } else {
        // ❌ Login failed
        Get.snackbar(
          "Failed",
          "Login failed (${response.statusCode})",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        log("Status Code :------ ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // ⚠️ Exception Handling
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      log("Error --------->>>>>>>>>>>>>>> $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Fetch current user (kept same)
  var isLoading1 = true.obs;
  var hasExpensePermission = false.obs;

  Future<void> fetchCurrentUser() async {
    try {
      isLoading1.value = true;
      final user = await authformRepo.fetchCurrentUser();

      hasExpensePermission.value = user.permissions.any(
        (p) =>
            p == "manage expense" ||
            p == "create expense" ||
            p == "edit expense" ||
            p == "delete expense",
      );
    } catch (e) {
      log("Error fetching user: $e");
    } finally {
      isLoading1.value = false;
    }
  }
}
