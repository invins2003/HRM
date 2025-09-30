// import 'package:erp_admin/module/auth/screens/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
//
// import '../../MainScreen/MainScreen.dart' show MainScreen;
// import 'forgotPassword.dart' show ForgotPassword;
//
// class Loginscreen extends StatefulWidget {
//   const Loginscreen({super.key});
//
//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }
//
// class _LoginscreenState extends State<Loginscreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   GlobalKey<FormState> emailKey = GlobalKey();
//   GlobalKey<FormState> passwordKey = GlobalKey();
//
//   bool _passwordVisible1 = false;
//   var emailerror;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "login",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                     fontSize: 26,
//                   ),
//                 ),
//                 SizedBox(height: 50),
//                 _CustomTextFeilCard(
//                   controller: emailController,
//                   formKey: emailKey,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Enter Email id";
//                     }
//                   },
//                   hint: "email",
//                   keyBoardType: TextInputType.emailAddress,
//                 ),
//                 _buildPasswordTextFieldCard(
//                   controller: passwordController,
//                   formKey: passwordKey,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "plase Enter Your Password";
//                     }
//                     return null;
//                   },
//                   isVisible: _passwordVisible1,
//                   troggleVisibility: () => setState(() {
//                     _passwordVisible1 = !_passwordVisible1;
//                   }),
//                   hint: 'password',
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 22),
//                       child: InkWell(
//                         onTap: () {
//                           Get.to(ForgotPassword());
//                         },
//                         child: Text('Forgot Password?'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 18),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width / 1.5,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       onPressed: () {
//                         if (emailKey.currentState!.validate() &&
//                             passwordKey.currentState!.validate()) {
//                           Get.to(MainScreen());
//                         }
//                         // Get.to(MainScreen());
//                       },
//                       child: Text(
//                         "Login",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text("Dont't have an account? "),
//                         InkWell(
//                           onTap: () {
//                             Get.to(SignUpScreen());
//                           },
//                           child: Text(
//                             "Sign up",
//                             style: TextStyle(color: Colors.green),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _CustomTextFeilCard({
//   required TextEditingController controller,
//   required GlobalKey<FormState> formKey,
//   required String? Function(String?) validator,
//   required String hint,
//   required TextInputType keyBoardType,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       padding: EdgeInsets.all(3),
//       margin: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: BoxBorder.all(width: 1),
//       ),
//       child: Form(
//         key: formKey,
//         child: TextFormField(
//           controller: controller,
//           maxLines: 1,
//           validator: validator,
//           keyboardType: keyBoardType,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             hintText: hint,
//             hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _buildPasswordTextFieldCard({
//   required TextEditingController controller,
//   required GlobalKey<FormState> formKey,
//   required String? Function(String?) validator,
//   required bool isVisible,
//   required VoidCallback troggleVisibility,
//   required String hint,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       padding: EdgeInsets.all(3),
//       margin: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: BoxBorder.all(width: 1),
//       ),
//       child: Form(
//         key: formKey,
//         child: TextFormField(
//           controller: controller,
//           validator: validator,
//           obscureText: !isVisible,
//           enableSuggestions: false,
//           autocorrect: false,
//           maxLines: 1,
//           keyboardType: TextInputType.visiblePassword,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             suffixIcon: IconButton(
//               onPressed: troggleVisibility,
//               icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
//             ),
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// import 'package:erp_admin/module/auth/screens/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart' show Get;
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import '../Controller/AuthCotroller.dart';
// import '../Controller/BiometricController.dart';
// import 'forgotPassword.dart';
//
// class Loginscreen extends StatefulWidget {
//   const Loginscreen({super.key});
//
//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }
//
// class _LoginscreenState extends State<Loginscreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   GlobalKey<FormState> formkey = GlobalKey();
//
//   bool _passwordVisible1 = false;
//   final BiometricController biometricController = Get.put(
//     BiometricController(),
//   );
//
//   final AuthController authController = Get.find<AuthController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: formkey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "login",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                       fontSize: 26,
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   _CustomTextFeilCard(
//                     controller: emailController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Enter Email id";
//                       }
//                       if (!RegExp(
//                         r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
//                       ).hasMatch(value.trim())) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                     hint: "email",
//                     keyBoardType: TextInputType.emailAddress,
//                   ),
//                   _buildPasswordTextFieldCard(
//                     controller: passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Enter Your Password";
//                       }
//                       return null;
//                       // if (!RegExp(
//                       //   r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$',
//                       // ).hasMatch(value)) {
//                       //   return 'Must be 6+ chars,include letter,number & special char';
//                       // }
//                       // return null;
//                     },
//                     isVisible: _passwordVisible1,
//                     troggleVisibility: () => setState(() {
//                       _passwordVisible1 = !_passwordVisible1;
//                     }),
//                     hint: 'password',
//                   ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.end,
//                   //   crossAxisAlignment: CrossAxisAlignment.end,
//                   //   children: [
//                   //     Padding(
//                   //       padding: const EdgeInsets.only(right: 22),
//                   //       child: InkWell(
//                   //         onTap: () {
//                   //           Get.to(ForgotPassword());
//                   //         },
//                   //         child: Text('Forgot Password?'),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   SizedBox(height: 18),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Obx(() {
//                       return authController.isLoading.value
//                           ? CircularProgressIndicator(color: Colors.green)
//                           : Container(
//                               height: 50,
//                               width: MediaQuery.of(context).size.width / 1.5,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                 ),
//                                 // onPressed: () {
//                                 //   // if (formkey.currentState!.validate()) {
//                                 //   //   Get.to(HomeScreen());
//                                 //   // }
//                                 // },
//                                 // onPressed: () async {
//                                 //   if (formkey.currentState!.validate()) {
//                                 //     await biometricController.enableBiometric();
//                                 //     if (biometricController
//                                 //         .isBiometricEnabled
//                                 //         .value) {
//                                 //       Get.off(Mainscreen());
//                                 //     }
//                                 //     biometricController
//                                 //         .askBiometricPermission();
//                                 //   }
//                                 //   // Get.to(Mainscreen());
//                                 // },
//                                 // onPressed: () async {
//                                 //   if (formkey.currentState!.validate()) {
//                                 //     bool success = await authController
//                                 //         .loginController(
//                                 //           emailController.text,
//                                 //           passwordController.text,
//                                 //         );
//                                 //
//                                 //     if (success) {
//                                 //       biometricController
//                                 //           .askBiometricPermission();
//                                 //     }
//                                 //   }
//                                 // },
//                                 onPressed: () async {
//                                   if (formkey.currentState!.validate()) {
//                                     bool success = await authController
//                                         .loginController(
//                                           emailController.text,
//                                           passwordController.text,
//                                         );
//
//                                     if (success) {
//                                       biometricController
//                                           .askBiometricPermission();
//                                     }
//                                   }
//                                 },
//
//                                 child: Text(
//                                   "Login",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             );
//                     }),
//                   ),
//                   SizedBox(height: 10),
//                   // Column(
//                   //   children: [
//                   //     Row(
//                   //       mainAxisAlignment: MainAxisAlignment.center,
//                   //       crossAxisAlignment: CrossAxisAlignment.center,
//                   //       children: [
//                   //         Text("Dont't have an account? "),
//                   //         InkWell(
//                   //           onTap: () {
//                   //             Get.to(SignUpScreen());
//                   //           },
//                   //           child: Text(
//                   //             "Sign up",
//                   //             style: TextStyle(color: Colors.green),
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ],
//                   //),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------- EMAIL TEXTFIELD ----------------
// Widget _CustomTextFeilCard({
//   required TextEditingController controller,
//   required String? Function(String?) validator,
//   required String hint,
//   required TextInputType keyBoardType,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: TextFormField(
//       controller: controller,
//       maxLines: 1,
//       validator: validator,
//       keyboardType: keyBoardType,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         hintText: hint,
//         hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.black, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.green, width: 1),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         errorStyle: TextStyle(
//           color: Colors.red,
//           fontSize: 12,
//           height: 0.8, // 👈 ensures error shows below the border
//         ),
//       ),
//     ),
//   );
// }
//
// // ---------------- PASSWORD TEXTFIELD ----------------
// Widget _buildPasswordTextFieldCard({
//   required TextEditingController controller,
//   required String? Function(String?) validator,
//   required bool isVisible,
//   required VoidCallback troggleVisibility,
//   required String hint,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: TextFormField(
//       controller: controller,
//       validator: validator,
//       obscureText: !isVisible,
//       enableSuggestions: false,
//       autocorrect: false,
//       maxLines: 1,
//       keyboardType: TextInputType.visiblePassword,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         suffixIcon: IconButton(
//           onPressed: troggleVisibility,
//           icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
//         ),
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.black, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.green, width: 1),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.red, width: 1),
//         ),
//         errorStyle: TextStyle(
//           color: Colors.red,
//           fontSize: 12,
//           height: 0.8, // 👈 ensures error shows below the border
//         ),
//       ),
//     ),
//   );
// }

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
