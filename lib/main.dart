// // import 'package:erp_admin/Routs/AppRouts.dart';
// // import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// // import 'package:erp_admin/module/auth/screens/signin.dart';
// // import 'package:erp_admin/utils/InitialBindings.dart' as dep;
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SystemChrome.setPreferredOrientations([
// //     DeviceOrientation.portraitUp,
// //     DeviceOrientation.portraitDown,
// //   ]);
// //   await dep.init();
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   Future<bool> checkLoginstatus() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     String? token = prefs.getString("USER_TOKEN");
// //     return token != null && token.isNotEmpty;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetMaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'HRM',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //       ),
// //       home: FutureBuilder<bool>(
// //         future: checkLoginstatus(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Scaffold(
// //               body: Center(child: CircularProgressIndicator()),
// //             );
// //           } else {
// //             if (snapshot.hasData && snapshot.data == true) {
// //               return Mainscreen();
// //             } else {
// //               return Loginscreen();
// //             }
// //           }
// //         },
// //       ),
// //       initialRoute: AppRouts.initialRouts,
// //       getPages: AppRouts.page,
// //     );
// //   }
// // }
//
// import 'package:erp_admin/Routs/AppRouts.dart';
// import 'package:erp_admin/module/MainScreen/MainScreen.dart';
// import 'package:erp_admin/module/auth/screens/signin.dart';
// import 'package:erp_admin/utils/InitialBindings.dart' as dep;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:local_auth/local_auth.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   await dep.init();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   Future<Widget> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("USER_TOKEN");
//     bool biometricEnabled = prefs.getBool("BIOMETRIC_ENABLED") ?? false;
//
//     if (token == null || token.isEmpty) {
//       return Loginscreen();
//     }
//
//     if (biometricEnabled) {
//       // try biometric auth
//       final auth = LocalAuthentication();
//       try {
//         bool authenticated = await auth.authenticate(
//           localizedReason: "Use fingerprint to login",
//           options: const AuthenticationOptions(
//             biometricOnly: true,
//             stickyAuth: true,
//           ),
//         );
//         if (authenticated) {
//           return Mainscreen();
//         } else {
//           return Loginscreen();
//         }
//       } catch (e) {
//         return Loginscreen();
//       }
//     } else {
//       return Loginscreen();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HRM',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: FutureBuilder<Widget>(
//         future: _checkLoginStatus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return snapshot.data ?? Loginscreen();
//         },
//       ),
//       initialRoute: AppRouts.initialRouts,
//       getPages: AppRouts.page,
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:local_auth/local_auth.dart';
// import 'module/auth/screens/signin.dart';
// import 'module/MainScreen/MainScreen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   Future<Widget> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("USER_TOKEN");
//     bool biometricEnabled = prefs.getBool("BIOMETRIC_ENABLED") ?? false;
//
//     if (token == null || token.isEmpty) {
//       return Loginscreen(); // First time or logged out
//     }
//
//     if (biometricEnabled) {
//       final auth = LocalAuthentication();
//       try {
//         bool authenticated = await auth.authenticate(
//           localizedReason: "Please authenticate with fingerprint",
//           options: const AuthenticationOptions(
//             biometricOnly: true,
//             stickyAuth: true,
//           ),
//         );
//
//         if (authenticated) {
//           return const Mainscreen();
//         } else {
//           return Loginscreen(); // If user cancels biometric
//         }
//       } catch (e) {
//         return Loginscreen();
//       }
//     } else {
//       return Loginscreen(); // If biometric not enabled
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HRM',
//       home: FutureBuilder<Widget>(
//         future: _checkLoginStatus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else {
//             return snapshot.data ?? Loginscreen();
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:erp_admin/utils/InitialBindings.dart' as dep;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'module/auth/screens/signin.dart';
import 'module/MainScreen/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("USER_TOKEN");
    bool biometricEnabled = prefs.getBool("BIOMETRIC_ENABLED") ?? false;

    // ✅ First time or logged out
    if (token == null || token.isEmpty) {
      return Loginscreen();
    }

    // ✅ If biometric was enabled
    if (biometricEnabled) {
      final auth = LocalAuthentication();
      try {
        bool authenticated = await auth.authenticate(
          localizedReason: "Please authenticate with fingerprint",
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          return const Mainscreen();
        } else {
          return Loginscreen(); // cancel → login manually
        }
      } catch (e) {
        return Loginscreen(); // fallback
      }
    }

    // ✅ If biometric not enabled → always go to login
    return Loginscreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRM',
      home: FutureBuilder<Widget>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.green,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          } else {
            return snapshot.data ?? Loginscreen();
          }
        },
      ),
      getPages: [
        GetPage(name: "/main", page: () => const Mainscreen()),
        GetPage(name: "/login", page: () => Loginscreen()),
      ],
    );
  }
}
