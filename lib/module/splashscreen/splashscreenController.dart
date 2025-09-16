// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../MainScreen/MainScreen.dart';
// import '../auth/Controller/AuthCotroller.dart';
// import '../auth/screens/signin.dart';
//
// class SplashController extends GetxController {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await _prefs;
//     final token = prefs.getString("USER_TOKEN");
//     final isBiometric = prefs.getBool("BIOMETRIC_ENABLED") ?? false;
//
//     if (token != null && token.isNotEmpty) {
//       // ✅ User already logged in
//       if (isBiometric) {
//         // show biometric check
//         Get.put(BiometricController()).askBiometricPermission();
//       } else {
//         // directly go to main
//         Get.offAll(Mainscreen());
//       }
//     } else {
//       // ❌ No login → go to login
//       Get.offAll(Loginscreen());
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainScreen/MainScreen.dart';
import '../auth/screens/signin.dart';

class SplashController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("USER_TOKEN");

    await Future.delayed(const Duration(seconds: 2)); // splash delay

    if (token != null && token.isNotEmpty) {
      _authenticate();
    } else {
      Get.offAll(() => Loginscreen());
    }
  }

  Future<void> _authenticate() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        Get.snackbar("Error", "Biometric not available");
        Get.offAll(() => Loginscreen());
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to access the app",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        Get.offAll(() => Mainscreen());
      } else {
        Get.offAll(() => Loginscreen());
      }
    } catch (e) {
      Get.snackbar("Error", "Biometric failed: $e");
      Get.offAll(() => Loginscreen());
    }
  }
}
