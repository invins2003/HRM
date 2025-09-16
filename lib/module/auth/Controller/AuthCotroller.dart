// // import 'package:get/get.dart';
// // import 'package:local_auth/local_auth.dart';
// //
// // class BiometricController extends GetxController {
// //   final LocalAuthentication auth = LocalAuthentication();
// //   RxBool isBiometricEnabled = false.obs;
// //
// //   Future<void> enableBiometric() async {
// //     try {
// //       bool canCheck = await auth.canCheckBiometrics;
// //       if (!canCheck) {
// //         Get.snackbar("Error", "Biometric not available");
// //         return;
// //       }
// //
// //       bool authenticated = await auth.authenticate(
// //         localizedReason: "Use fingerprint to continue",
// //         options: AuthenticationOptions(biometricOnly: true, stickyAuth: true),
// //       );
// //
// //       if (authenticated) {
// //         isBiometricEnabled.value = true;
// //         Get.snackbar("Success", "Biometric enabled");
// //       }
// //     } catch (e) {
// //       Get.snackbar("Error", "Biometric failed: $e");
// //     }
// //   }
// // }
//
// import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// import 'package:erp_admin/module/auth/Model/loginModel.dart';
// import 'package:erp_admin/utils/Constant.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Repo/AuthRepo.dart';
//
// class Controller extends GetxController {
//   final AuthRepo authformRepo;
//   Controller({required this.authformRepo});
//
//   RxBool isLoading = false.obs;
//
//   Future<bool> loginController(String email, String password) async {
//     try {
//       isLoading.value = true;
//
//       Response response = await authformRepo.authRepo(email, password);
//       final prefs = await SharedPreferences.getInstance();
//
//       if (response.statusCode == 200) {
//         // isLoading.value = true;
//         final loginModel = LoginModel.fromJson(response.body);
//         Fluttertoast.showToast(msg: "Login Successful");
//         Get.snackbar("Success", "Login Successful");
//         Get.to(Mainscreen());
//         prefs.setString("USER_TOKEN", loginModel.token ?? "");
//         prefs.setBool("BIOMETRIC_ENABLED", true);
//         Constants.TOKEN = loginModel.token.toString();
//         return true;
//       } else {
//         // isLoading.value = false;
//         Fluttertoast.showToast(msg: "Login failed");
//         print("Login failed ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Something went wrong: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
// //------ this code for Biometric ----------
// //
// // class BiometricController extends GetxController {
// //   final LocalAuthentication auth = LocalAuthentication();
// //   RxBool isBiometricEnabled = false.obs;
// //
// //   void askBiometricPermission() {
// //     Get.dialog(
// //       AlertDialog(
// //         backgroundColor: Colors.white,
// //         title: const Text("Enable Biometric"),
// //         content: const Text("Do you want to enable fingerprint login?"),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Get.offAll(Mainscreen());
// //             },
// //             child: const Text("No"),
// //           ),
// //           TextButton(
// //             onPressed: () async {
// //               await _authenticateAndEnable(); // wait for auth
// //               if (isBiometricEnabled.value) {
// //                 Get.offAll(Mainscreen()); // navigate only if enabled
// //               }
// //             },
// //             child: const Text("Yes"),
// //           ),
// //         ],
// //       ),
// //       barrierDismissible: false,
// //     );
// //   }
// //
// //   Future<void> _authenticateAndEnable() async {
// //     Get.back(); // close dialog
// //     try {
// //       bool canCheck = await auth.canCheckBiometrics;
// //       if (!canCheck) {
// //         Get.snackbar("Error", "Biometric not available");
// //         // _goToMain();
// //         Get.offAll(Mainscreen());
// //         return;
// //       }
// //
// //       bool authenticated = await auth.authenticate(
// //         localizedReason: "Use fingerprint to continue",
// //         options: const AuthenticationOptions(
// //           biometricOnly: true,
// //           stickyAuth: true,
// //         ),
// //       );
// //
// //       if (authenticated) {
// //         isBiometricEnabled.value = true;
// //         Get.snackbar("Success", "Biometric enabled");
// //       }
// //     } catch (e) {
// //       Get.snackbar("Error", "Biometric failed: $e");
// //     }
// //   }
// //
// //   // void _goToMain() {
// //   //   Get.off(Mainscreen());
// //   // }
// // }
//
// class BiometricController extends GetxController {
//   final LocalAuthentication auth = LocalAuthentication();
//   RxBool isBiometricEnabled = false.obs;
//
//   void askBiometricPermission() {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.white,
//         title: const Text("Enable Biometric"),
//         content: const Text("Do you want to enable fingerprint login?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.offAll(Mainscreen());
//             },
//             child: const Text("No"),
//           ),
//           TextButton(
//             onPressed: () async {
//               await _authenticateAndEnable();
//             },
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   Future<void> _authenticateAndEnable() async {
//     Get.back(); // close dialog
//
//     try {
//       bool canCheck = await auth.canCheckBiometrics;
//       if (!canCheck) {
//         Get.snackbar("Error", "Biometric not available");
//         Get.offAll(Mainscreen()); // go to main if not available
//         return;
//       }
//
//       bool authenticated = await auth.authenticate(
//         localizedReason: "Use fingerprint to continue",
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );
//
//       if (authenticated) {
//         isBiometricEnabled.value = true;
//         Get.snackbar("Success", "Biometric enabled");
//         Get.offAll(Mainscreen());
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Biometric failed: $e");
//       Get.offAll(Mainscreen());
//     }
//   }
// }
//
// import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// import 'package:erp_admin/module/auth/Model/loginModel.dart';
// import 'package:erp_admin/utils/Constant.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Repo/AuthRepo.dart';
// import 'BiometricController.dart';
//
// class Controller extends GetxController {
//   final AuthRepo authformRepo;
//   Controller({required this.authformRepo});
//
//   RxBool isLoading = false.obs;
//
//   Future<bool> loginController(String email, String password) async {
//     try {
//       isLoading.value = true;
//
//       Response response = await authformRepo.authRepo(email, password);
//       final prefs = await SharedPreferences.getInstance();
//
//       if (response.statusCode == 200) {
//         final loginModel = LoginModel.fromJson(response.body);
//         Fluttertoast.showToast(msg: "Login Successful");
//         Get.snackbar("Success", "Login Successful");
//
//         // Save token
//         await prefs.setString("USER_TOKEN", loginModel.token ?? "");
//         Constants.TOKEN = loginModel.token.toString();
//
//         // ask biometric dialog
//         final bioCtrl = Get.put(BiometricController());
//         bioCtrl.askBiometricPermission();
//
//         return true;
//       } else {
//         Fluttertoast.showToast(msg: "Login failed");
//         return false;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Something went wrong: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
// import 'package:erp_admin/module/auth/Model/loginModel.dart';
// import 'package:erp_admin/utils/Constant.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Repo/AuthRepo.dart';
// import 'BiometricController.dart';
//
// class Controller extends GetxController {
//   final AuthRepo authformRepo;
//   Controller({required this.authformRepo});
//
//   RxBool isLoading = false.obs;
//
//   Future<bool> loginController(String email, String password) async {
//     try {
//       isLoading.value = true;
//       Response response = await authformRepo.authRepo(email, password);
//       final prefs = await SharedPreferences.getInstance();
//
//       if (response.statusCode == 200) {
//         final loginModel = LoginModel.fromJson(response.body);
//         Fluttertoast.showToast(msg: "Login Successful");
//         Get.snackbar("Success", "Login Successful");
//
//         // Save token
//         await prefs.setString("USER_TOKEN", loginModel.token ?? "");
//         Constants.TOKEN = loginModel.token.toString();
//
//         // Ask biometric (only first time after login)
//         final bioCtrl = Get.put(BiometricController());
//         bioCtrl.askBiometricPermission();
//
//         return true;
//       } else {
//         Fluttertoast.showToast(msg: "Login failed");
//         return false;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Something went wrong: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:erp_admin/module/auth/Model/loginModel.dart';
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
        Fluttertoast.showToast(msg: "Login failed");
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
}
