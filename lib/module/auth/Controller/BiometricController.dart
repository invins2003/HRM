
import 'package:erp_admin/AppColors/AppColors.dart';
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
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: kButtonGradient,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enable Biometric",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Do you want to enable fingerprint login for next time?",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("BIOMETRIC_ENABLED", false);
                      Get.offAll(() => const Mainscreen());
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      await _authenticateAndEnable();
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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