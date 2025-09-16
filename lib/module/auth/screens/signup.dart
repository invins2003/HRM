// // import 'package:erp_admin/module/auth/screens/signin.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import '../../MainScreen/MainScreen.dart' show MainScreen;
// //
// // class SignUpScreen extends StatefulWidget {
// //   const SignUpScreen({super.key});
// //
// //   @override
// //   State<SignUpScreen> createState() => _SignUpScreenSate();
// // }
// //
// // class _SignUpScreenSate extends State<SignUpScreen> {
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController passwordController = TextEditingController();
// //   TextEditingController nameController = TextEditingController();
// //   TextEditingController mobileController = TextEditingController();
// //   TextEditingController reentercontroller = TextEditingController();
// //
// //   GlobalKey<FormState> emailKey = GlobalKey();
// //   GlobalKey<FormState> passwordKey = GlobalKey();
// //   GlobalKey<FormState> namekey = GlobalKey();
// //   GlobalKey<FormState> mobileNumberkey = GlobalKey();
// //   GlobalKey<FormState> reenterPasswordkey = GlobalKey();
// //
// //   bool _passwordVisible1 = false;
// //   bool _passwordvisible2 = false;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Center(
// //           child: SingleChildScrollView(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "Sign Up",
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.green,
// //                     fontSize: 26,
// //                   ),
// //                 ),
// //                 _CustomTextFeilCard(
// //                   controller: nameController,
// //                   formKey: namekey,
// //                   validator: (value) {},
// //                   hint: "Full name",
// //                   keyBoardType: TextInputType.emailAddress,
// //                 ),
// //                 _CustomTextFeilCard(
// //                   controller: emailController,
// //                   formKey: emailKey,
// //                   validator: (value) {},
// //                   hint: "Email id",
// //                   keyBoardType: TextInputType.emailAddress,
// //                 ),
// //                 _CustomTextFeilCard(
// //                   controller: mobileController,
// //                   formKey: mobileNumberkey,
// //                   validator: (value) {},
// //                   hint: "Mobile no",
// //                   keyBoardType: TextInputType.emailAddress,
// //                 ),
// //                 _buildPasswordTextFieldCard(
// //                   controller: passwordController,
// //                   formKey: passwordKey,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return "plase Enter Your Password";
// //                     }
// //                     return null;
// //                   },
// //                   isVisible: _passwordVisible1,
// //                   troggleVisibility: () => setState(() {
// //                     _passwordVisible1 = !_passwordVisible1;
// //                   }),
// //                   hint: 'Password',
// //                 ),
// //                 _buildPasswordTextFieldCard(
// //                   controller: reentercontroller,
// //                   formKey: reenterPasswordkey,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return "plase Enter Your Password";
// //                     }
// //                     return null;
// //                   },
// //                   isVisible: _passwordvisible2,
// //                   troggleVisibility: () => setState(() {
// //                     _passwordvisible2 = !_passwordvisible2;
// //                   }),
// //                   hint: 'Reenter Password',
// //                 ),
// //                 SizedBox(height: 18),
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     height: 50,
// //                     width: MediaQuery.of(context).size.width / 1.5,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.green,
// //                       ),
// //                       onPressed: () {
// //                         Get.to(MainScreen());
// //                       },
// //                       child: Text(
// //                         "Sign Up",
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 10),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     Text("Already have an account? "),
// //                     InkWell(
// //                       onTap: () {
// //                         Get.to(Loginscreen());
// //                       },
// //                       child: Text(
// //                         "Login",
// //                         style: TextStyle(color: Colors.green),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // Widget _CustomTextFeilCard({
// //   required TextEditingController controller,
// //   required GlobalKey<FormState> formKey,
// //   required String? Function(String?) validator,
// //   required String hint,
// //   required TextInputType keyBoardType,
// // }) {
// //   return Padding(
// //     padding: const EdgeInsets.all(8.0),
// //     child: Container(
// //       padding: EdgeInsets.all(3),
// //       margin: EdgeInsets.symmetric(horizontal: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20),
// //         border: BoxBorder.all(width: 1),
// //       ),
// //       child: Form(
// //         key: formKey,
// //         child: TextFormField(
// //           controller: controller,
// //           maxLines: 1,
// //           validator: validator,
// //           keyboardType: keyBoardType,
// //           decoration: InputDecoration(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //             hintText: hint,
// //             hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
// //             border: InputBorder.none,
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // Widget _buildPasswordTextFieldCard({
// //   required TextEditingController controller,
// //   required GlobalKey<FormState> formKey,
// //   required String? Function(String?) validator,
// //   required bool isVisible,
// //   required VoidCallback troggleVisibility,
// //   required String hint,
// // }) {
// //   return Padding(
// //     padding: const EdgeInsets.all(8.0),
// //     child: Container(
// //       padding: EdgeInsets.all(3),
// //       margin: EdgeInsets.symmetric(horizontal: 10),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20),
// //         border: BoxBorder.all(width: 1),
// //       ),
// //       child: Form(
// //         key: formKey,
// //         child: TextFormField(
// //           controller: controller,
// //           validator: validator,
// //           obscureText: !isVisible,
// //           enableSuggestions: false,
// //           autocorrect: false,
// //           maxLines: 1,
// //           keyboardType: TextInputType.visiblePassword,
// //           decoration: InputDecoration(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //             suffixIcon: IconButton(
// //               onPressed: troggleVisibility,
// //               icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
// //             ),
// //             hintText: hint,
// //             hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
// //             border: InputBorder.none,
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
//
// import 'package:erp_admin/module/auth/screens/signin.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../DashBoard/Screens/DashBoardScreen.dart' show Dashboardscreen;
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenSate();
// }
//
// class _SignUpScreenSate extends State<SignUpScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController reenterController = TextEditingController();
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   bool _passwordVisible1 = false;
//   bool _passwordVisible2 = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                       fontSize: 26,
//                     ),
//                   ),
//                   _CustomTextFeilCard(
//                     controller: nameController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your full name";
//                       }
//                       return null;
//                     },
//                     hint: "Full name",
//                     keyBoardType: TextInputType.name,
//                   ),
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
//                     hint: "Email id",
//                     keyBoardType: TextInputType.emailAddress,
//                   ),
//                   _CustomTextFeilCard(
//                     controller: mobileController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your mobile number";
//                       }
//                       return null;
//                     },
//                     hint: "Mobile no",
//                     keyBoardType: TextInputType.phone,
//                   ),
//                   _buildPasswordTextFieldCard(
//                     controller: passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Enter Your Password";
//                       }
//                       if (!RegExp(
//                         r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$',
//                       ).hasMatch(value)) {
//                         return 'Must be 6+ chars,include letter,number & special char';
//                       }
//                       return null;
//                     },
//                     isVisible: _passwordVisible1,
//                     troggleVisibility: () => setState(() {
//                       _passwordVisible1 = !_passwordVisible1;
//                     }),
//                     hint: 'Password',
//                   ),
//                   _buildPasswordTextFieldCard(
//                     controller: reenterController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Enter Your Password";
//                       }
//                       if (!RegExp(
//                         r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{6,}$',
//                       ).hasMatch(value)) {
//                         return 'Must be 6+ chars,include letter,number & special char';
//                       }
//                       return null;
//                     },
//                     isVisible: _passwordVisible2,
//                     troggleVisibility: () => setState(() {
//                       _passwordVisible2 = !_passwordVisible2;
//                     }),
//                     hint: 'Re-enter Password',
//                   ),
//                   SizedBox(height: 18),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 50,
//                       width: MediaQuery.of(context).size.width / 1.5,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () {
//                           if (formKey.currentState!.validate()) {
//                             Get.to(Dashboardscreen());
//                           }
//                         },
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text("Already have an account? "),
//                       InkWell(
//                         onTap: () {
//                           Get.to(Loginscreen());
//                         },
//                         child: Text(
//                           "Login",
//                           style: TextStyle(color: Colors.green),
//                         ),
//                       ),
//                     ],
//                   ),
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
// // ---------------- COMMON TEXTFIELD ----------------
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
//         errorStyle: TextStyle(color: Colors.red, fontSize: 12, height: 0.8),
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
//         errorStyle: TextStyle(color: Colors.red, fontSize: 12, height: 0.8),
//       ),
//     ),
//   );
// }
