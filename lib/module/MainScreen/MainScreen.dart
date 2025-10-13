import 'package:erp_admin/module/auth/Controller/AuthCotroller.dart';
import 'package:erp_admin/module/auth/Repo/AuthRepo.dart';
import 'package:erp_admin/module/expense/screens/expense_screen.dart';
import 'package:erp_admin/module/profile/screens/myprofile_screen.dart';
import 'package:erp_admin/utils/ApiClient.dart';
import 'package:erp_admin/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../DashBoard/Screens/DashBoardScreen.dart';
import '../EmployeeList&Profile/Screens/EmployeeListScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0;

  late AuthController authController;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize UserController
   authController = Get.put(AuthController(authformRepo: AuthRepo(apiClient: ApiClient(appBaseUrl: Constants.BASEURL))));
      // Run after the first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    authController.fetchCurrentUser();
  });
  }

  void _onTabSelected(int index) {
    if (_selectedIndex == index) {
      // If the tab is already selected, pop to the first route
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<String> _screenTitles = ['DashBoard', 'EmployeeList', 'Expense', 'Profile'];

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (index) {
            case 0:
              page = Dashboardscreen();
              break;
            case 1:
              page = EmployeeScreen();
              break;
            case 2:
              page = ExpenseScreen();
              break;
            case 3:
              page = ProfileScreen();
              break;
            default:
              page = Dashboardscreen();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_navigatorKeys[_selectedIndex].currentState!.canPop()) {
      _navigatorKeys[_selectedIndex].currentState!.pop();
      return Future.value(false); 
    } else {
      if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Wait for user permissions to load
      if (authController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.green)),
        );
      }

      // Determine which tabs to show
      List<BottomNavigationBarItem> bottomItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'DashBoard'),
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'EmployeeList'),
      ];

      List<Widget> screens = [
        Dashboardscreen(),
        EmployeeScreen(),
      ];

      // Add Expense tab only if user has permission
      if (authController.hasExpensePermission.value) {
        bottomItems.add(
          const BottomNavigationBarItem(icon: Icon(Icons.wallet_rounded), label: "Branch Wallet"),
        );
        screens.add(ExpenseScreen());
      }

      // Always add Profile tab
      bottomItems.add(
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      );
      screens.add(ProfileScreen());

      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              _screenTitles[_selectedIndex],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.green,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            items: bottomItems,
          ),
        ),
      );
    });
  }
}
