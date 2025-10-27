import 'package:erp_admin/module/Logout/Repo/LogoutRepo.dart';
import 'package:erp_admin/module/auth/Model/ErrorModel.dart';
import 'package:erp_admin/module/auth/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/LogoutSuccessModel.dart';

class LogoutController extends GetxController {
  final LogoutRepo logoutRepo;
  LogoutController({required this.logoutRepo});
  RxBool isloading = false.obs;

  // Future<void> logout() async {
  //   try {
  //     isloading.value = true;
  //     Response response = await logoutRepo.Logout();
  //     final prfs = await SharedPreferences.getInstance();
  //     if (response.statusCode == 200) {
  //       isloading.value = false;
  //       final successModel = SuccessLogoutModel.formJson(response.body);
  //       print(response);
  //       print(response.statusCode);
  //       await prfs.remove("USER_TOKEN");
  //
  //       Fluttertoast.showToast(msg: successModel.message.toString());
  //       Get.offAll(Loginscreen());
  //     } else {
  //       isloading.value = false;
  //       final errorModel = ErrorModel.fromJson(response.body);
  //       Fluttertoast.showToast(msg: errorModel.message.toString());
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isloading.value = false;
  //   }
  // }
  Future<void> logout() async {
    try {
      isloading.value = true;
      Response response = await logoutRepo.Logout();
      final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        isloading.value = false;
        final successModel = SuccessLogoutModel.formJson(response.body);

        // Clear both token and biometric flag
        await prefs.remove("USER_TOKEN");
        await prefs.remove("BIOMETRIC_ENABLED");
        //
        // Fluttertoast.showToast(msg: successModel.message.toString());
        //
        Get.snackbar("Success", "Logout Successfully");

        // Navigate to login
        Get.offAll(() => LoginScreen());
      } else {
        isloading.value = false;
        final errorModel = ErrorModel.fromJson(response.body);
        // Fluttertoast.showToast(msg: errorModel.message.toString());
        Get.snackbar(
          "failed",
          errorModel.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error ----> ${e}");
    } finally {
      isloading.value = false;
    }
  }
}
