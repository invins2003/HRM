

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../AppColors/AppColors.dart';
import '../Controller/AuthCotroller.dart';
import '../Controller/BiometricController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  bool _passwordVisible = false;

  final BiometricController biometricController = Get.put(
    BiometricController(),
  );
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  /// 🔹 App Logo or Icon
                  ///
                  SizedBox(height: 50),
                  Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// 🔹 Card for login form
                  Card(
                    elevation: 5,
                    color: kCardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          /// Email Field
                          _buildTextField(
                            controller: emailController,
                            hint: "Email Address",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Email id";
                              }
                              if (!RegExp(
                                r'^[\w.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
                              ).hasMatch(value.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          /// Password Field
                          _buildPasswordField(
                            controller: passwordController,
                            hint: "Password",
                            isVisible: _passwordVisible,
                            toggle: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your password";
                              }
                              return null;
                            },
                          ),

                          /// Forgot Password
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: () {},
                          //
                          //     // => Get.to(() => ForgotPassword()),
                          //     child: const Text(
                          //       "Forgot Password?",
                          //       style: TextStyle(color: Colors.green),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 20),

                          /// Login Button
                          Obx(() {
                            return authController.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.green,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          bool success = await authController
                                              .loginController(
                                                emailController.text,
                                                passwordController.text,
                                              );
                                          if (success) {
                                            biometricController
                                                .askBiometricPermission();
                                          }
                                        }
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: kButtonGradient,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Signup Link
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Don't have an account? "),
                  //     InkWell(
                  //       onTap: () {},
                  //       // => Get.to(() => SignUpScreen()),
                  //       child: Text(
                  //         "Sign Up",
                  //         style: TextStyle(
                  //           color: Colors.green.shade800,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------- Custom TextField ----------------
Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required String? Function(String?) validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.green),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

/// ---------------- Password TextField ----------------
Widget _buildPasswordField({
  required TextEditingController controller,
  required String hint,
  required bool isVisible,
  required VoidCallback toggle,
  required String? Function(String?) validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: !isVisible,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.green,
        ),
        onPressed: toggle,
      ),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
