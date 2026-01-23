import 'package:erp_admin/config/env_config.dart';
import 'package:erp_admin/module/DashBoard/Screens/DashBoardScreen.dart';
import 'package:erp_admin/theme/themes.dart';
import 'package:erp_admin/utils/InitialBindings.dart' as dep;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'module/auth/screens/signin.dart';
import 'module/MainScreen/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  await FlutterWindowManagerPlus.addFlags(
    FlutterWindowManagerPlus.FLAG_SECURE,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);

  await dep.init();
 runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// ✅ Check login token only (no biometric)
  Future<Widget> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("USER_TOKEN");

    if (token != null && token.isNotEmpty) {
      return const Dashboardscreen();
    } else {
      return LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRM',
      theme: AppTheme.buildThemeData(context),
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
