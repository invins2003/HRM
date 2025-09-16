// import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//             onPressed: () async {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool("BIOMETRIC_ENABLED", false);
//               Get.offAll(() => const Mainscreen());
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
//     try {
//       bool canCheck = await auth.canCheckBiometrics;
//       if (!canCheck) {
//         Get.snackbar("Error", "Biometric not available");
//         Get.offAll(() => const Mainscreen());
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
//       final prefs = await SharedPreferences.getInstance();
//
//       if (authenticated) {
//         isBiometricEnabled.value = true;
//         await prefs.setBool("BIOMETRIC_ENABLED", true);
//         Get.snackbar("Success", "Biometric enabled");
//         Get.offAll(() => const Mainscreen());
//       } else {
//         await prefs.setBool("BIOMETRIC_ENABLED", false);
//         Get.offAll(() => const Mainscreen());
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Biometric failed: $e");
//       Get.offAll(() => const Mainscreen());
//     }
//   }
// }
//
// import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BiometricController extends GetxController {
//   final LocalAuthentication auth = LocalAuthentication();
//   RxBool isBiometricEnabled = false.obs;
//
//   /// Show dialog only after first login
//   void askBiometricPermission() {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.white,
//         title: const Text("Enable Biometric"),
//         content: const Text("Do you want to enable fingerprint login?"),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool("BIOMETRIC_ENABLED", false);
//               Get.offAll(() => const Mainscreen());
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
//   /// Authenticate and enable biometric
//   Future<void> _authenticateAndEnable() async {
//     Get.back(); // close dialog
//     try {
//       bool canCheck = await auth.canCheckBiometrics;
//       if (!canCheck) {
//         Get.snackbar("Error", "Biometric not available");
//         Get.offAll(() => const Mainscreen());
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
//       final prefs = await SharedPreferences.getInstance();
//
//       if (authenticated) {
//         isBiometricEnabled.value = true;
//         await prefs.setBool("BIOMETRIC_ENABLED", true);
//         Get.snackbar("Success", "Biometric enabled");
//         Get.offAll(() => const Mainscreen());
//       } else {
//         await prefs.setBool("BIOMETRIC_ENABLED", false);
//         Get.offAll(() => const Mainscreen());
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Biometric failed: $e");
//       Get.offAll(() => const Mainscreen());
//     }
//   }
// }

import 'package:erp_admin/module/MainScreen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  RxBool isBiometricEnabled = false.obs;

  /// Show dialog only after first login
  void askBiometricPermission() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.green,
        title: const Text(
          "Enable Biometric",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Do you want to enable fingerprint login for next time?",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("BIOMETRIC_ENABLED", false);
              Get.offAll(() => const Mainscreen());
            },
            child: const Text("No", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              await _authenticateAndEnable();
            },
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Authenticate and enable biometric
  Future<void> _authenticateAndEnable() async {
    Get.back(); // close dialog
    try {
      bool canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        Get.snackbar("Error", "Biometric not available");
        Get.offAll(() => const Mainscreen());
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: "Use fingerprint to continue",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      final prefs = await SharedPreferences.getInstance();

      if (authenticated) {
        isBiometricEnabled.value = true;
        await prefs.setBool("BIOMETRIC_ENABLED", true);
        Get.snackbar("Success", "Biometric enabled");
        Get.offAll(() => const Mainscreen());
      } else {
        await prefs.setBool("BIOMETRIC_ENABLED", false);
        Get.offAll(() => const Mainscreen());
      }
    } catch (e) {
      Get.snackbar("Error", "Biometric failed: $e");
      Get.offAll(() => const Mainscreen());
    }
  }
}
