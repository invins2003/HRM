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
      return LoginScreen();
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
          return LoginScreen(); // cancel → login manually
        }
      } catch (e) {
        return LoginScreen(); // fallback
      }
    }

    // ✅ If biometric not enabled → always go to login
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRM',
      theme: ThemeData(
        primarySwatch: Colors.green, // ✅ green shades
        scaffoldBackgroundColor: Colors.white, // ✅ clean white background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.green,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
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
            return snapshot.data ?? LoginScreen();
          }
        },
      ),
      getPages: [
        GetPage(name: "/main", page: () => const Mainscreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
      ],
    );
  }
}
